Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1CZLmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 07:42:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41185 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1CZLmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 07:42:11 -0400
Subject: Re: [PATCH 1/3] ASoC: imx: set watermarks for mx2-dma
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: alsa-devel@alsa-project.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@freescale.com>, Jarkko Nikula <jhnikula@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1301068306-11997-2-git-send-email-w.sang@pengutronix.de>
References: <1301068306-11997-1-git-send-email-w.sang@pengutronix.de>
	 <1301068306-11997-2-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 11:42:04 +0000
Message-ID: <1301139725.3455.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 16:51 +0100, Wolfram Sang wrote:
> They got accidently removed by f0fba2a (ASoC: multi-component - ASoC
> Multi-Component Support). Reintroduce them and get rid of the
> superfluous defines because the fiq-driver has its own hardcoded values.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---

Acked-by: Liam Girdwood <lrg@ti.com>


