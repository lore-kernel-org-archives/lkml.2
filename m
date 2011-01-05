Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1AENEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:04:31 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:40141 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1AENEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:04:30 -0500
Message-ID: <4D246C54.9060503@free.fr>
Date: Wed, 05 Jan 2011 14:04:20 +0100
From: Julien Boibessot <julien.boibessot@free.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org, liu.y.victor@gmail.com,
        B02280@freescale.com, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2] i.MX51 Framebuffer support
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sascha Hauer a écrit :
> The following series adds i.MX51 framebuffer support based on the IPUv3. It
> is not perfect but I decided it is good enough to open it for a wider audience
> and collect first reviews. I tested this on a babbage board using both outputs
> (VGA/DVI) with different resolutions up to 1680x1050 and different colour depths.
> I also tested it on one custom board using a fixed display setting.
>   
This driver is also working fine for me on a custom i.MX51 board with a
800x480 18 bits TFT LCD (16bpp mode).

The only strange thing I noticed was a kind of uggly sprite/artefact
(32x32, I would say) appearing at the same time as the Linux console. I
think it may be related to a hardware cursor badly (?) initialised, but
I didn't find a fix yet.
It disappears when I launch a graphical application (Qt or SDL).

Regards,
Julien
