Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1CZLm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 07:42:29 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37577 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1CZLm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 07:42:27 -0400
Subject: Re: [PATCH 2/3] ASoC: imx: fix burstsize for DMA
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: alsa-devel@alsa-project.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@freescale.com>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1301068306-11997-3-git-send-email-w.sang@pengutronix.de>
References: <1301068306-11997-1-git-send-email-w.sang@pengutronix.de>
	 <1301068306-11997-3-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 11:42:20 +0000
Message-ID: <1301139740.3455.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 16:51 +0100, Wolfram Sang wrote:
> SSI counts in words, the DMA engine in bytes. (Wrong) factor got removed
> in bf974a0 (ASoC i.MX: switch to new DMA api).
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Liam Girdwood <lrg@ti.com>

