Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0LHKvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:51:37 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37679 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0LHKvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:51:36 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 0/2] Common struct clk implementation, v8
Date: Wed, 8 Dec 2010 18:51:22 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1291774094.269634.503532219345.0.gpush@pororo> <20101208103355.GK18244@pengutronix.de>
In-Reply-To: <20101208103355.GK18244@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012081851.23218.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

> I would have expected that clk-common is an ancestor of clk-common-mx51.
> Currently it bases on v7(?) that doesn't have the spinlock.
> 
> BTW, I took a quick look over the patches in clk-common-mx51 and I think
> arch/arm/plat-mxc/include/mach/clock.h doesn't compile without
> CONFIG_USE_COMMON_STRUCT_CLK (because then there is no struct clk_mxc),
> so either you need more magic or just remove the #ifndef
> CONFIG_USE_COMMON_STRUCT_CLK.

Ah, I haven't pushed updates to the clk-common-mx51 branch yet, I'll get to 
this soon.

Cheers,


Jeremy
