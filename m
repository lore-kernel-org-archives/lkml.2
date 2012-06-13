Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2FMDbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:31:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:57815 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab2FMDbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:31:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155572143"
From: Andi Kleen <andi@firstfloor.org>
To: "Yan\, Zheng" <zheng.z.yan@intel.com>
Cc: Stephane Eranian <eranian@google.com>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com>
	<4FD7EFCB.6060005@intel.com>
Date: Tue, 12 Jun 2012 20:31:44 -0700
In-Reply-To: <4FD7EFCB.6060005@intel.com> (Zheng Yan's message of "Wed, 13 Jun
	2012 09:41:31 +0800")
Message-ID: <m2obonj3a7.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yan, Zheng" <zheng.z.yan@intel.com> writes:

> Peter suggests keeping the uncore names as they're listed in the intel
> doc. For Sandybirdge-EP, uncore names are something like: Cbo, iMC, QPI.
> I think Uncore_Cbo_0 appears better than uncore_Cbo_0

How about a case insensitive match for the sysfs directories? That can
be implemented in user land with nftw(). Since sysfs is all virtual
it should not be too expensive, as long as you only walk the pmu
parts.

I think that would be most user friendly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
