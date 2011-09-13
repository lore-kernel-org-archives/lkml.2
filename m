Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1IMSNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:13:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53163 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1IMSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:13:08 -0400
Date: Tue, 13 Sep 2011 23:42:45 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110913181245.GN11100@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1315830943.26517.36.camel@twins>
 <20110913041545.GD11100@linux.vnet.ibm.com>
 <20110913050306.GB7254@linux.vnet.ibm.com>
 <1315906788.575.3.camel@twins>
 <20110913112852.GE7254@linux.vnet.ibm.com>
 <1315922848.5977.11.camel@twins>
 <20110913162119.GA3045@linux.vnet.ibm.com>
 <1315931775.5977.29.camel@twins>
 <20110913175425.GB3062@linux.vnet.ibm.com>
 <1315936984.4226.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1315936984.4226.2.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11091318-2398-0000-0000-00000030BE99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 20:03:04]:

> On Tue, 2011-09-13 at 23:24 +0530, Srivatsa Vaddagiri wrote:
> > Fyi, we have added additional levels to cgroup setup
> > (/Level1/Level2/C1/C1_1 etc) to mimic cgroup hierarchy for VMS as
> > created by libvirt. 
> 
> The deeper you nest the bigger the numerical problems get.. 
>
> Also, can you please stop using virt crap and focus on useful
> things? :-) 

That unfortunately is the target environment where we want this working
(want to cap VMs under KVM) :-) For simplicity, we have been playing
with non-VM based testcase ..

> Start with simple cases of single depth groups.

We did try with single level and "extra" large proportional
shares (10k * NR_TASKS if I recall)..I don't think they made any 
difference ..will re-check though.

- vatsa

