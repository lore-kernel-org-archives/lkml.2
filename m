Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0LLAzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 19:55:35 -0500
Received: from 63.mail-out.ovh.net ([91.121.185.56]:36767 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752324Ab0LLAze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 19:55:34 -0500
Date: Sun, 12 Dec 2010 01:50:48 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Igor Plyatov <plyatov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, ryan@bluewatersys.com,
        christian.glindkamp@taskit.de, pgsellmann@portner-elektronik.at
Subject: Re: [PATCH v4] mach-at91: Support for gsia18s board added
Message-ID: <20101212005048.GH19897@game.jcrosoft.org>
References: <1292000411-6691-1-git-send-email-plyatov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292000411-6691-1-git-send-email-plyatov@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2123728700418730855
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:00 Fri 10 Dec     , Igor Plyatov wrote:
> The GS_IA18_S (GMS) is a carrier board from GeoSIG Ltd used with the
> Stamp9G20 SoM from Taskit company.
> It operate as an internet accelerometer.
> 
> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> ---
>  arch/arm/configs/gsia18s_defconfig        |  147 +++++++
please no new defconfig
start to merge them


your patch contain a lots of whitespace please fix it
> +
> +/*
> + * Up to date linux/arch/arm/tools/mach-types database required to support this.
> +MACHINE_START(GSIA18S, "GS_IA18_S")
> +*/
> +MACHINE_START(STAMP9G20, "GS_IA18_S")
if you do this you must use system_rev to identify the board
> +	.boot_params	= AT91_SDRAM_BASE + 0x100,
> +	.timer		= &at91sam926x_timer,
> +	.map_io		= gsia18s_map_io,
> +	.init_irq	= init_irq,
> +	.init_machine	= gsia18s_board_init,
> +MACHINE_END
Best Regards,
J.
