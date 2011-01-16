Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1APSAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:00:46 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:50025 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1APSAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:00:44 -0500
Date: Sun, 16 Jan 2011 11:00:42 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] arm: omap: remove duplicated headers
In-Reply-To: <1295174783-4099-2-git-send-email-balbi@ti.com>
Message-ID: <alpine.DEB.2.00.1101161059190.13225@utopia.booyaka.com>
References: <1295174783-4099-1-git-send-email-balbi@ti.com> <1295174783-4099-2-git-send-email-balbi@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jan 2011, Felipe Balbi wrote:

> A few headers are included twice, remove them.
> 
> Found the following errors using make includecheck:
> arch/arm/mach-omap2/clock44xx_data.c: prm44xx.h is
> included more than once.
> arch/arm/mach-omap2/clockdomains44xx_data.c: cm1_44xx.h
> is included more than once.
> arch/arm/mach-omap2/clockdomains44xx_data.c: cm2_44xx.h
> is included more than once.
> arch/arm/mach-omap2/powerdomain2xxx_3xxx.c: prm-regbits-34xx.h
> is included more than once.

These are probably merge-related.  I'll take this patch for 2.6.38-rc.

Thanks,


- Paul
