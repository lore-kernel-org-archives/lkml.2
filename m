Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab2BJPxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:53:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40953 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab2BJPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:53:46 -0500
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling
 related to cpusets
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, paul@paulmenage.org, rjw@sisk.pl,
        tj@kernel.org, frank.rowand@am.sony.com, pjt@google.com,
        tglx@linutronix.de, lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <4F3386E9.7090606@linux.vnet.ibm.com>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
	 <1328671335.2482.72.camel@laptop> <4F32174E.2050207@linux.vnet.ibm.com>
	 <20120209075701.GE18387@elte.hu>  <4F3386E9.7090606@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 16:53:29 +0100
Message-ID: <1328889209.25989.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 14:12 +0530, Srivatsa S. Bhat wrote:
> 
> So, from my point of view, cpusets seems to be handling CPU Offline pretty
> well, and correctly too. The corresponding CPU online handling is what is
> buggy, IMHO, and that is what I intended to fix with this patchset. 

No, online is not buggy, since offline is destructive of the cpuset
state (it has to) you cannot undo it.



