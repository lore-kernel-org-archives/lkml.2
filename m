Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab2IKPfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:35:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab2IKPft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:35:49 -0400
Message-ID: <504F5A18.8080701@redhat.com>
Date: Tue, 11 Sep 2012 11:34:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Youquan Song <youquan.song@linux.intel.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        ShuoX Liu <shuox.liu@intel.com>, youquan.song@intel.com
Subject: Re: KS/Plumbers: c-state governor BOF
References: <5037B36A.8000209@redhat.com> <20120912024342.GA23544@linux-youquan.bj.intel.com>
In-Reply-To: <20120912024342.GA23544@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 10:43 PM, Youquan Song wrote:
>> After talking about my RFC patches to the c-state governor with
>> Matthew and Arjan, it is clear that the whole concept of how
>> things are done could use some more discussion.
>>
>> Since a good number of us will be in San Diego next week, at
>> Kernel Summit / Plumbers / etc, I will organize a c-state
>> governor BOF for those who are interested.
>>
>> Things to think about:
>> - what should the c-state governor do?
>> - how to best predict the future?
>> - what kinds of odd workloads do we need to accomodate?
>
> Hi Rik,
>
> Just notice there is a topic to discuss menu governor at Kernel Summit.
> Acutally, I have posted a patchset to at May 11 2012 to bring up the
> topic, at that time, I only have a convinced and proved application
> turbostat v1 to prove that my patch are useful. I try to find other
> workloads to prove that the patchset are also solidated useful. But I
> stucked in other high priority tasks, so I move slow on it.
>  From you bring up the issue I guess that you already has real workload
> to show this issue.
> My patchset is not only improve repeat mode failure but also improve
> general prediction failure. Let's have a discuss and talk about it.
>
> Here is the patchset posted at May 11 2012.
>
> http://lwn.net/Articles/496919/ "x86,idle: Enhance cpuidle prediction to
> handle its failure"
> http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/02267.html
> "[PATCH 1/3] x86,idle: Quickly notice prediction failure for repeat mode"
> http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/02268.html
> "[PATCH 2/3] x86,idle: Quickly notice prediction failure in general case"
> http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/02269.html
> "[PATCH 3/3] x86,idle: Set residency to 0 if target Cstate not really
> enter"

Your patches could make a lot of sense when integrated with my
patches:

http://people.redhat.com/riel/cstate/

However, we should probably get the tracepoint upstream first,
so we can know for sure :)

-- 
All rights reversed
