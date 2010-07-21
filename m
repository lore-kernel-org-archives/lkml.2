Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301Ab0GUSUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:20:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:51088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab0GUSUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:20:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,239,1278313200"; 
   d="scan'208";a="302783123"
Subject: Re: [PATCH 0/7] x86, xsave: some code cleanups and reworks, -v2
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 21 Jul 2010 11:19:54 -0700
Message-Id: <1279736394.2812.7.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 10:03 -0700, Robert Richter wrote:
> Hans Peter, Suresh, and Cyrill, thanks for your feedback.
> 
> This is version 2 of the patch series.
> 
> Patches 2, 4, 7 are unchanged compared to -v1.
> 
> Patch 1 folds the initialization code into one patch. fpu_init() is
> now called before xsave_init(). xsave_init() can later overwrite
> xstate_size based on xstate features.
> 
> Patch 3 replaces all hardcoded XSTATE_CPUID values know. cpuid_level
> is now taken from boot_cpu_data.
> 
> Patches 5 and 6 are new:
> * add __init attribute to setup_xstate_features()
> * disable xsave in i387 emulation mode

Apart from the cleanup comments that I had for "[PATCH 6/7] x86, xsave:
disable xsave in i387 emulation mode", all other patches look good to
me.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Thanks.

