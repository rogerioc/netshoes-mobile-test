//
//  HomeViewModel.swift
//  RCSGitHUBApi
//
//  Created by Rogerio on 10/11/17.
//  Copyright © 2017 rogeriocs. All rights reserved.
//

import Foundation

class HomeViewModel: HomeViewModelProtocol{
    var gitHubApi : GitHubApiProtocol?
    var persistRepository:PersistRepositoryProtocol?
    var page:Int = 0
    weak var publicRepositoriesDelegate:GetPublicRepositories?
    
    required init(gitHubApi:GitHubApiProtocol){
        self.gitHubApi = gitHubApi
        //self.persistRepository = persistRepository
    }
    
    func getRepositories() {
        page = 0
        self.persistRepository?.deleteData()
        getData();
    }
    
    func getNextData() {
        page += 1
        getData()
    }
    
    func getData(){
        self.publicRepositoriesDelegate?.repositoriesIsLoading(true)
       
        gitHubApi?.getPublicRepositories(page: page, success: { (gitHubModel) in
            let showGitHubModels = gitHubModel.map{ HelperConvert.gitHubApiModelToGitHubShow($0)}
            self.publicRepositoriesDelegate?.repositoriesSuccess(data: showGitHubModels)
            self.publicRepositoriesDelegate?.repositoriesIsLoading(false)
        }) { (code, reason) in
            self.publicRepositoriesDelegate?.repositoriesError(code ?? 0)
            self.publicRepositoriesDelegate?.repositoriesIsLoading(false)
        }
    }
    
     
}

