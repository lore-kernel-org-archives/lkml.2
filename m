Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2GGDVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 23:21:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:56557 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2GGDVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 23:21:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119730541"
Message-ID: <4FF7AB30.50405@intel.com>
Date: Sat, 07 Jul 2012 11:21:20 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com,
        "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: Re: Fwd: Re: [linux-next-20120706] x86/mm: incompatible pointer typewarning.
References: <4FF6F14C.3070104@intel.com> <4FF6F1E9.7050709@intel.com> <201207070943.DBB17689.FOMQJtOFLHOVFS@I-love.SAKURA.ne.jp>
In-Reply-To: <201207070943.DBB17689.FOMQJtOFLHOVFS@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2012 08:43 AM, Tetsuo Handa wrote:

> Alex Shi wrote:
>> Thanks for your report, mm should means mm_struct. no vma. My fault.
>> Could you like try this patch.
> 
> Builds OK. Thank you.


Uh, seems the allnoconfig setting is different on different tree.
I need to tired it other tree no just Linus' tree. :(

> 
>> From 97781231b130e7f7fced12244653ed9b9946c944 Mon Sep 17 00:00:00 2001
>> From: Alex Shi <alex.shi@intel.com>
>> Date: Fri, 6 Jul 2012 20:49:25 +0800
>> Subject: [PATCH] x86/tlb: fix allnoconfig building warning
>>
>> The incompatible parameter of flush_tlb_mm_range cause build warning.
>> Fix it by correct parameter.



-- 
Thanks
    Alex
