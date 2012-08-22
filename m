Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab2HVTKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:10:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1284 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2HVTKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:10:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6811"; a="225991222"
Message-ID: <50352EB9.4000402@codeaurora.org>
Date: Wed, 22 Aug 2012 12:10:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Fix XIP build due to PHYS_OFFSET definition moving
References: <1343956994-27513-1-git-send-email-sboyd@codeaurora.org> <5024AE2D.5050506@codeaurora.org>
In-Reply-To: <5024AE2D.5050506@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/12 23:46, Stephen Boyd wrote:
> On 8/2/2012 6:23 PM, Stephen Boyd wrote:
>> During the p2v changes, the PHYS_OFFSET #define moved into a
>> !__ASSEMBLY__ section. This causes a XIP build to fail with
>>
>>  arch/arm/kernel/head.o: In function 'stext':
>>  arch/arm/kernel/head.S:146: undefined reference to 'PHYS_OFFSET'
>>
>> Momentarily leave the #ifndef __ASSEMBLY__ section so we can
>> define PHYS_OFFSET for all compilation units.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>
>> I don't know if it's worth stable, seems that nobody has compiled XIP for
>> a year (back to 2.6.39 days?).
> Is this approach acceptable? Shall I put this in the patch tracker?
>

I'll take silence to mean "yes", so I'll put this in the patch tracker
unless someone objects.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

