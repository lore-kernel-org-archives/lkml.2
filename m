Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1GTXgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 19:36:31 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56220 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1GTXga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 19:36:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6413"; a="104763449"
Message-ID: <4E27667D.9060200@codeaurora.org>
Date: Wed, 20 Jul 2011 16:36:29 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Imre Kaloz <kaloz@openwrt.org>, Eric Miao <eric.y.miao@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] ARM: Migrate to asm-generic wrapper support
References: <1311204225-13169-1-git-send-email-sboyd@codeaurora.org> <20110720232819.GC20310@n2100.arm.linux.org.uk>
In-Reply-To: <20110720232819.GC20310@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 04:28 PM, Russell King - ARM Linux wrote:
> On Wed, Jul 20, 2011 at 04:23:45PM -0700, Stephen Boyd wrote:
>> With d8ecc5c (kbuild: asm-generic support, 2011-04-27) we can
>> remove a handful of asm-generic wrappers in ARM code.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: Imre Kaloz <kaloz@openwrt.org>
>> Cc: Krzysztof Halasa <khc@pm.waw.pl>
>> Cc: Eric Miao <eric.y.miao@gmail.com>
>> ---
>>
>> I've specifically left out topology.h as it looks like that will not
>> be generic much longer.
>
> You don't mention in the commit log about the change to SZ_48M.
>

Sorry. I figured it was a minor detail. How about:

With d8ecc5c (kbuild: asm-generic support, 2011-04-27) we can
remove a handful of asm-generic wrappers in ARM code. Since the
generic version of sizes.h doesn't contain SZ_48M, we replace
the 3 users of SZ_48M with the equivalent SZ_32M + SZ_16M.


? If that works I'll make sure to include it when submitting to the
patch tracker.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

