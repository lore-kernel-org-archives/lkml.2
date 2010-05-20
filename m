Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0ETGwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 02:52:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0ETGwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 02:52:10 -0400
Date: Thu, 20 May 2010 08:51:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520065143.GA14480@elte.hu>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <4BF46000.20203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF46000.20203@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4997]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> [...]
> 
> Have you looked at Lin Ming's patch series?  I think it 
> offers another way to support IBS and other 
> arch-specific and off-chip PMUs in a more general way, 
> though it's not quite fully-baked yet.

Robert, check out this thread on lkml:

  [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs

Here is Peter's post that describes the high level design:

  http://groups.google.com/group/linux.kernel/msg/ab9aa075016c639e

And please help out Lin Ming with this work - we dont want 
to add new, special-purpose ABI extensions for enumeration 
purposes, it should be introduced using a new event_source 
node via the sysfs enumeration.

Whether IBS fits that category is an open question - 
ideally it should have similar high level usage as the 
PEBS/LBR bits on Intel CPUs. (at least as far as tooling 
goes)

Thanks,

	Ingo
