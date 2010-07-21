Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0GUU4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:56:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab0GUU4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:56:01 -0400
Message-ID: <4C475EC9.6020009@zytor.com>
Date: Wed, 21 Jul 2010 13:55:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] x86, xsave: some code cleanups and reworks, -v2
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
In-Reply-To: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 10:03 AM, Robert Richter wrote:
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
> 

Please note that I did integrate some of your patches already.  I might
need you to rebase; I'll know in a few minutes.

	-hpa
