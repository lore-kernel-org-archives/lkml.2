Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab2ILPSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:18:45 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:40328 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759990Ab2ILPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:18:42 -0400
Date: Wed, 12 Sep 2012 15:18:42 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Vaibhav Hiremath <hvaibhav@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH] ARM: OMAP2+: dpll: Add missing soc_is_am33xx() check
 for common functions
In-Reply-To: <1345820064-5243-1-git-send-email-hvaibhav@ti.com>
Message-ID: <alpine.DEB.2.00.1209121518170.17903@utopia.booyaka.com>
References: <1345820064-5243-1-git-send-email-hvaibhav@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Vaibhav Hiremath wrote:

> Add missing soc_is_am33xx() check for DPLL common control & clock
> related functions, without this dpll programmability would be broken
> for am33xx family of devices.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> ---
> Not sure whether this should go as a fix in -rc, as AM33XX device
> doesn't still boot without hwmod data (which is not yet upstream).
> 
>  arch/arm/mach-omap2/clkt_dpll.c |    4 ++--
>  arch/arm/mach-omap2/dpll3xxx.c  |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Thanks, queued for 3.7 along with the AM33xx hwmod patches.


- Paul
