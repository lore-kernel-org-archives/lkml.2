Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1AKLaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:30:15 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52284 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab1AKLaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:30:13 -0500
Date: Tue, 11 Jan 2011 13:30:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: manjunatha_halli@ti.com
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC V10 6/7] drivers:media:radio: wl128x: Kconfig & Makefile
 for wl128x driver
Message-ID: <20110111113008.GF2385@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-5-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-6-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-7-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294745487-29138-7-git-send-email-manjunatha_halli@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 11, 2011 at 06:31:26AM -0500, manjunatha_halli@ti.com wrote:
> diff --git a/drivers/media/radio/wl128x/Makefile b/drivers/media/radio/wl128x/Makefile
> new file mode 100644
> index 0000000..32a0ead
> --- /dev/null
> +++ b/drivers/media/radio/wl128x/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for TI's shared transport driver based wl128x
> +# FM radio.
> +#
> +obj-$(CONFIG_RADIO_WL128X)	+= fm_drv.o
> +fm_drv-objs		:= fmdrv_common.o fmdrv_rx.o fmdrv_tx.o fmdrv_v4l2.o

there was recently a patch fixing up this kind of thing. Look at commit
0a2b8a0d1101179fdebc974a7c72b514aede9d9d.

This should be written as:

obj-$(CONFIG_RADIO_WL128X) += fm_drv.o
fm_drv-y	:= fmdrv_common.o fmdrv_rx.o fmdrv_tx.o fmdrv_v4l2.o

-- 
balbi
