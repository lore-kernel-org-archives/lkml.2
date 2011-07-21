Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1GUSgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:36:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31619 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1GUSgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:36:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6414"; a="104888949"
Message-ID: <4E2871AE.8030603@codeaurora.org>
Date: Thu, 21 Jul 2011 11:36:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Eric Miao <eric.y.miao@gmail.com>, Imre Kaloz <kaloz@openwrt.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Migrate to asm-generic wrapper support
References: <1311204225-13169-1-git-send-email-sboyd@codeaurora.org>	<20110720232819.GC20310@n2100.arm.linux.org.uk>	<4E27667D.9060200@codeaurora.org> <m31uxje8o4.fsf@intrepid.localdomain>
In-Reply-To: <m31uxje8o4.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 12:27 PM, Krzysztof Halasa wrote:
> Stephen Boyd <sboyd@codeaurora.org> writes:
>
>> With d8ecc5c (kbuild: asm-generic support, 2011-04-27) we can
>> remove a handful of asm-generic wrappers in ARM code. Since the
>> generic version of sizes.h doesn't contain SZ_48M, we replace
>> the 3 users of SZ_48M with the equivalent SZ_32M + SZ_16M.
> Perhaps simply adding SZ_48M to the generic version is better. Can live
> with either.

This was simpler (1 patch, 1 maintainer). Is that an ack?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

