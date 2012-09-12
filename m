Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab2IKOmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:42:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:56811 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759267Ab2IKOl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:41:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,405,1344236400"; 
   d="scan'208";a="201547364"
Date: Tue, 11 Sep 2012 22:43:42 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        ShuoX Liu <shuox.liu@intel.com>, youquan.song@intel.com
Subject: Re: KS/Plumbers: c-state governor BOF
Message-ID: <20120912024342.GA23544@linux-youquan.bj.intel.com>
References: <5037B36A.8000209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5037B36A.8000209@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After talking about my RFC patches to the c-state governor with
> Matthew and Arjan, it is clear that the whole concept of how
> things are done could use some more discussion.
>
> Since a good number of us will be in San Diego next week, at
> Kernel Summit / Plumbers / etc, I will organize a c-state
> governor BOF for those who are interested.
>
> Things to think about:
> - what should the c-state governor do?
> - how to best predict the future?
> - what kinds of odd workloads do we need to accomodate?

Hi Rik,

Just notice there is a topic to discuss menu governor at Kernel Summit.
Acutally, I have posted a patchset to at May 11 2012 to bring up the
topic, at that time, I only have a convinced and proved application 
turbostat v1 to prove that my patch are useful. I try to find other
workloads to prove that the patchset are also solidated useful. But I
stucked in other high priority tasks, so I move slow on it.
>From you bring up the issue I guess that you already has real workload
to show this issue. 
My patchset is not only improve repeat mode failure but also improve 
general prediction failure. Let's have a discuss and talk about it.

Here is the patchset posted at May 11 2012.

http://lwn.net/Articles/496919/ "x86,idle: Enhance cpuidle prediction to
handle its failure"
http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/02267.html
"[PATCH 1/3] x86,idle: Quickly notice prediction failure for repeat mode"
http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/02268.html
"[PATCH 2/3] x86,idle: Quickly notice prediction failure in general case"
http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/02269.html
"[PATCH 3/3] x86,idle: Set residency to 0 if target Cstate not really
enter"

Thanks
-Youquan
