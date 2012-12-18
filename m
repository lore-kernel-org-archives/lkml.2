Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2LRSr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:47:26 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11351 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2LRSrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:47:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,310,1355126400"; 
   d="scan'208";a="14910972"
Message-ID: <50D0BA2D.2020600@codeaurora.org>
Date: Tue, 18 Dec 2012 10:47:09 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, nico@linaro.org,
        will.deacon@arm.com, marc.zyngier@arm.com, john.stultz@linaro.org
Subject: Re: [RFC PATCH 1/5] ARM: remove useless guard in smp.c
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com> <1355832418-31692-2-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1355832418-31692-2-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/12 04:06, Mark Rutland wrote:
> Currently we only provide an implementation of smp_timer_broadcast in
> smp.c if GENERIC_CLOCKEVENTS_BROADCAST is selected. As
> smp_timer_broadcast is only used in smp.c, smp.c depends on SMP, and
> GENERIC_CLOCKEVENTS_BROADCAST is selected by SMP, this is unnecessary.

You might want to add that GENERIC_CLOCKEVENTS_BROADCAST depends on
GENERIC_CLOCKEVENTS and SMP depends on GENERIC_CLOCKEVENTS too.

> This patch removes the redundant guard.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

