Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab0FPDyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 23:54:54 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39565 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab0FPDyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 23:54:52 -0400
Date: Wed, 16 Jun 2010 12:54:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, linux-sh@vger.kernel.org,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] soc/sh: Fix I2C dependency for SND_FSI_AK4642 and SND_FSI_DA7210
Message-ID: <20100616035440.GA29614@linux-sh.org>
References: <201006141739.42346.PeterHuewe@gmx.de> <201006151649.07554.PeterHuewe@gmx.de> <20100615151913.GJ14510@rakim.wolfsonmicro.main> <201006151738.56143.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006151738.56143.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 05:38:55PM +0200, Peter Huewe wrote:
> The config option SND_FSI_AK4642 selects SND_SOC_AK4642 which in turn
> enables the compilation of ak4642.c - however this codec uses I2C to
> communicate with the HW.
> Same applies to DA7210.
> 
It uses I2C, but it doesn't matter which I2C master it's interfaced with.
A simple depends on I2C will suffice for this purpose just fine.
