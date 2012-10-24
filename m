Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab2JXJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:09:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:7632 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab2JXJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:09:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="239409317"
Message-ID: <5087AE05.60606@intel.com>
Date: Wed, 24 Oct 2012 16:59:49 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] perf/x86/uncore: Handle pci_read_config_dword() error.
References: <1351068140-13456-1-git-send-email-zheng.z.yan@intel.com> <20121024085813.GA2509@gmail.com>
In-Reply-To: <20121024085813.GA2509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 04:58 PM, Ingo Molnar wrote:
> 
> * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> 
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 43 +++++++++++++++++----------
>>  1 file changed, 28 insertions(+), 15 deletions(-)
> 
> Thanks, nice fixes.
> 
> Was this runtime tested on a real Sandy Bridge-EP et al CPU so 
> that we know that it does not regress anything?
> 

Yes, I have tested it on Sandy Bridge-EP.

Regards
Yan, ZHedng

