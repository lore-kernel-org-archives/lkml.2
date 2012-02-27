Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2B0Goe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:44:34 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39179 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2B0God (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:44:33 -0500
Date: Mon, 27 Feb 2012 12:14:23 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
Message-ID: <20120227064423.GC28139@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4F3DEDC3.4010004@linux.vnet.ibm.com>
 <4F3F025B.5010400@linux.vnet.ibm.com>
 <1329743311.2293.341.camel@twins>
 <4F4617AB.2080401@linux.vnet.ibm.com>
 <4F46F105.2000702@linux.vnet.ibm.com>
 <4F48E882.6090409@linux.vnet.ibm.com>
 <20120227041259.GA2331@linux.vnet.ibm.com>
 <4F4B0F90.6050601@linux.vnet.ibm.com>
 <20120227051021.GB28139@linux.vnet.ibm.com>
 <4F4B2105.4080306@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F4B2105.4080306@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022620-9264-0000-0000-000000EAA858
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Wang <wangyun@linux.vnet.ibm.com> [2012-02-27 14:21:57]:
> I think I really need some study on cgroup first...I've done some totally useless 
> test :( ,

Yes!

> but still confused that why sys time reduced?

Could be just noise ..

> And I got a server with Redhat now, so I will do:
> 
> 1. cgcreate -g cpu:/subcg1
> 2. echo $$ > /cgroup/cpu/subcg1/tasks
> 3. open another shell
> 4. do 1~3 multi times, plan to get 7 cpu cgroup with 7 shell attached to each one.
> 5. run kernbench in each shell
> 
> Please tell me if I missed some thing :)

That should stress the cgroup-specific paths of scheduler!

-vatsa

