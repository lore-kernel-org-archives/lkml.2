Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3AGUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:09:29 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:53977 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3AGUJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:09:28 -0500
Date: Mon, 7 Jan 2013 20:09:26 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Afzal Mohammed <afzal@ti.com>
Subject: Re: [PATCH] omap: am33xx-hwmod: Fix wrongly terminated am33xx_usbss_mpu_irqs
 array
In-Reply-To: <20130107200338.GD14149@atomide.com>
Message-ID: <alpine.DEB.2.00.1301072009170.31833@utopia.booyaka.com>
References: <1357252342-6166-1-git-send-email-panto@antoniou-consulting.com> <20130107200338.GD14149@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [130103 14:35]:
> > The IRQ array must be terminated by -1 and not by -1+OMAP_INTC_START
> > This led to having a resource list of 100s of IRQs.
> 
> This is a bug for sure introduced with commit a2cfc509 (ARM: OMAP3+:
> hwmod: Add AM33XX HWMOD data). Anybody care to ack this one?

Acked-by: Paul Walmsley <paul@pwsan.com>


- Paul
