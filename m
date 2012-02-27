Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab2B0FKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:10:32 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57163 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2B0FKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:10:31 -0500
Date: Mon, 27 Feb 2012 10:40:21 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
Message-ID: <20120227051021.GB28139@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4F3D0F41.1010205@linux.vnet.ibm.com>
 <1329402561.2293.225.camel@twins>
 <4F3DEDC3.4010004@linux.vnet.ibm.com>
 <4F3F025B.5010400@linux.vnet.ibm.com>
 <1329743311.2293.341.camel@twins>
 <4F4617AB.2080401@linux.vnet.ibm.com>
 <4F46F105.2000702@linux.vnet.ibm.com>
 <4F48E882.6090409@linux.vnet.ibm.com>
 <20120227041259.GA2331@linux.vnet.ibm.com>
 <4F4B0F90.6050601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F4B0F90.6050601@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022705-2000-0000-0000-0000068C9ACE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Wang <wangyun@linux.vnet.ibm.com> [2012-02-27 13:07:28]:

> > Is that benchmark run in root (cpu) cgroup? If so, reweight_entity() should not
> > kick in at all.
> 
> 
> That's right, if no children group, 'reweight_entity' won't be called, so I have
> created a cpuset group under root group named 'rg1', and created a memory group
> under 'rg1' named 'sub', I attached the current shell to the 'sub' cgroup.

'cpu' and 'cpuset' cgroup resource controllers are separate. By above
steps, you would still be running kern-bench in root cgroup as far as cpu
cgroup controller is concerned ..

- vatsa

