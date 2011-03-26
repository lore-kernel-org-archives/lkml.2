Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1CZLmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 07:42:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41185 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1CZLmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 07:42:33 -0400
Subject: Re: [PATCH 3/3] ASoC: imx: remove superfluous code in imx-ssi.c
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: alsa-devel@alsa-project.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@freescale.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1301068306-11997-4-git-send-email-w.sang@pengutronix.de>
References: <1301068306-11997-1-git-send-email-w.sang@pengutronix.de>
	 <1301068306-11997-4-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 11:42:29 +0000
Message-ID: <1301139749.3455.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 16:51 +0100, Wolfram Sang wrote:
> Checking if IMX_SSI_DMA is set and then set it again is useless.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Liam Girdwood <lrg@ti.com>

