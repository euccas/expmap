# Book: Continous Delivery

Reliable Software Releases Through Build, Test, and Deployment Automation

Authors: Jez Humble, David Farley

# Chapter 1: The Problem of Delivering Software

## Some Common Release Antipatterns

* Deploying software manually
* Deploying to a Production-like environment only after development is complete
* Manual configuration management of production environments

## Automated Deployment

Our goal is to describe the use of deployment pipelines, combined with high levels of automation of both testing and deployment and comprehensive configuration management to deliver push-button software releases. That is, push-button software releases to any deployment target -- development, test, or production.

How to deliver useful, working software to users as quickly as possible?

* Speed
* Quality (an important part of usefulness)
* Make frequent, automated releases of software
     * Automated
     * Frequent
* Feedback is essential to frequent, automated releases
     * Three criteria for feedback to be useful
          * Any change, of whatever kind, needs to trigger the feedback process (including four components: executable code, configuration, host environment, and data)
          * The feedback must be delivered (and received) as soon as possible.
          * The delivery team must receive feedback and then act on it.

Benefits of the above approach

* Empowering teams
* Reducing errors
* Lowering stress
* Deployment flexibility
* Practice makes perfect

## The Release Candidate

What is a *release candidate*? A change to your code may or may not be releasable. It is the build, deployment, and test process that we apply to that change that validates whether the change can be released.

Most approaches to releasing software identify release candidates at the end of the process. This makes some sense when there is work associated with the tracking.

Traditional view of release candidates (source: wikipedia):

```
Pre-alpha -> Alpha -> Beta -> Release candidate -> Gold
```

* Delay the nomination of a release candidate until several lengthy and expensive steps have been taken to ensure that the software is of sufficient quality and functionally complete
* In an environment where build and deployment automation is aggressively pursued along with comprehensive automated testing, there is no need to spend time and money on lengthy and manually intensive testing at the end of the project
* Indeed, delaying testing until after the development process, in our experience, a sure-fire way to decrease the quality of your application. Defects are best discovered and fixed at the point where they are introduced. When they are discovered later, they are always more expensive to fix.

Every check-in leads to a potential release.

In software, when something is painful, the way to reduce the pain is to do it more frequently, not less. Instead of integrating infrequently, we should integrate frequently; in fact, we should integrate as a result of every single change to the system.

## Principles of Software Delivery

* Create a repeatable, reliable process for releasing software
* Automate almost everything
* Keep everything in version control
* If it hurts, do it more frequently, and bring the pain forward
* Build quality in
* Done means released
* Everybody is responsible for the delivery process
* Continuous improvement

## Summary

* The stress associated with software releases and their manual, error-prone nature are related factors.
* By adopting the techniques of automated build, test, and deployment, we gain many benefits.
* The automation of development, test, and release processes has a profound impact on the speed, quality, and cost of releasing software.
# Chapter 2: Configuration Management

Configuration management is a term that is widely used, often as a synonym for version control.

One informal definition: Configuration management refers to the process by which all artifacts relevant to your project, and the relationships between them, are stored, retrieved, uniquely identified, and modified.

## Using Version Control

Version control systems, also known as source control, source code management systems, or revision control systems, are a mechanism for keeping multiple versions of your files.

In essence, the aim of a version control system is twofold: First, it retains, and provides access to, every version of every file that has ever been stored in it. Such systems also provide a way for metadata -- that is, information that describes the data stored -- to be attached to single files or collections of files. Second, it allows teams that may be distributed across space and time to collaborate.

Why use version control? Two fundamental questions:

* What constitutes a particular version of your software? How can you reproduce a particular state of the software's binaries and configuration that existed in the production environment?
* What was done when, by whom, and for what reason? Not only is this useful to know when things go wrong, but it also tells the story of your application


Advice on how to make the most effective use of version control
- Keep absolutely everything in version control: Version control isn't just for source code. Every single artifact related to the creation of your software should be under version control.
- Check in regularly to trunk
- Use meaningful commit messages: Every version control system has the facility to add a description to your commit. The most important reason to write descriptive commit messages is so that, when the build breaks, you know who broke the build and why.

## Managing Dependencies

What are the common Antipatterns in Software Delivery?

1. Deploying Software Manually

The signs of this antipattern are: (Some)
*
Detailed documentation that describes the steps to be taken and the ways in which the steps may go wrong
*
Reliance on manual testing to confirm that the application is running correctly
*
Frequent calls to the development team to explain why a deployment is going wrong on a release day
*
Frequent corrections to the release process during the course of release
*
Releases that are unpredictable in their outcome, that often have to be rolled back or run into unforeseen problems

2. Deploying to a Production-like Environment Only after Development is complete

test doubles (stubs, mocks, dummies)
A key part of automated testing involves replacing part of a system at run time with a simulated version. In this way, the interactions of the part of the application under test with the rest of the application can be tightly constrained, so that its behavior can be determined more easily. Such simulations are often known as mocks, stubs, dummies, and so forth.


canary releasing

Canary releasing, as shown in Figure 10.3, involves rolling out a new version of an application to a subset of the production servers to get fast feedback. Like a canary in a coal mine, this quickly uncovers any problems with the new version without impacting the majority of users

http://martinfowler.com/bliki/CanaryRelease.html

acceptance testing: functional tests, nonfunctional tests

real-life situations and strategies
* new projects
* midproject

Michael Feathers, in his book Working Effectively with Legacy Code , provocatively defined legacy systems as systems that do not have automated tests.
修改代码的艺术

Should only write automated tests where they will deliver value.
You can essentially divide your application into two parts. There is the code that implements the features of your application, and there is the support or framework code underneath it.
The vast majority of regression bugs are caused by altering framework code—so if you are only adding features to your application that do not require changes to the framework and support code, then there’s little value in writing a comprehensive scaffolding.
The exception to this is when your software has to run in a number of different environments.

Integration Testing
If your application is conversing with a variety of external systems through a series of different protocols, or if your application itself consists of a series of loosely coupled modules with complex interactions between them, then integration tests become very important.

Normally, integration tests should run in two contexts: firstly with the system under test running against the real external systems it depends on, or against their replicas controlled by the service provider, and secondly against a test harness which you create as part of your codebase.

    In software testing, a test harness or automated test framework is a collection of software and test data configured to test a program unit by running it under varying conditions and monitoring its behavior and outputs. It has two main parts: the test execution engine and the testscript repository.

You should test your application against as many pathological (病理学的) situations as you can simulate to make sure it can handle them.
In his excellent book Release It, Michael Nygard popularized the Circuit Breaker pattern to prevent this kind of catastrophic cascade.

Every time you have to integrate with an external system, you add risks to your project.


霍桑效应

# Chapter 11

Eucalyptus system
https://en.wikipedia.org/wiki/Eucalyptus_(software)

configurability

shared-nothing architecture
A shared nothing architecture (SN) is a distributed computingarchitecture in which each node is independent and self-sufficient, and there is no single point of contention across the system. More specifically, none of the nodes share memory or disk storage.

splunk: http://www.splunk.com/en_us/solutions/solution-areas/it-operations-management/microsoft-infrastructure-monitoring.html

### three categories of cloud computing
* applications in the cloud
* platforms in the cloud
* infrastructure in the cloud






