Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0KHNsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:48:06 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35898 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab0KHNsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:48:04 -0500
Subject: Re: [PATCH] ASoC: s3c24xx: Fix compilation problem.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Jassi Brar <jassi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289218491-17700-1-git-send-email-marek.belisko@gmail.com>
References: <1289218491-17700-1-git-send-email-marek.belisko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 13:47:59 +0000
Message-ID: <1289224079.3288.121.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 13:14 +0100, Marek Belisko wrote:
> When make mini2440_defconfig compilation end with undefined
> references to DMA functions. There was missing selection
> for S3C2410_DMA when compile ASoC audio for S3C24xx CPU.
> Tested on mini2440 board.
> 
> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

