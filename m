Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0KHRUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:20:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56840 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755012Ab0KHRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:20:43 -0500
Date: Mon, 8 Nov 2010 17:20:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: Jassi Brar <jassi.brar@samsung.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: s3c24xx: Fix compilation problem.
Message-ID: <20101108172048.GD12581@opensource.wolfsonmicro.com>
References: <1289218491-17700-1-git-send-email-marek.belisko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289218491-17700-1-git-send-email-marek.belisko@gmail.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 01:14:51PM +0100, Marek Belisko wrote:
> When make mini2440_defconfig compilation end with undefined
> references to DMA functions. There was missing selection
> for S3C2410_DMA when compile ASoC audio for S3C24xx CPU.
> Tested on mini2440 board.
> 
> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>

Applied, thanks.
