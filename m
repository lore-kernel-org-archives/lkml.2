Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab0FOPTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:19:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42549 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757280Ab0FOPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:19:15 -0400
Date: Tue, 15 Jun 2010 16:19:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-sh@vger.kernel.org,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc/sh: Fix I2C dependency for SND_FSI_AK4642
Message-ID: <20100615151913.GJ14510@rakim.wolfsonmicro.main>
References: <201006141739.42346.PeterHuewe@gmx.de>
 <20100614161034.GF14604@rakim.wolfsonmicro.main>
 <201006151649.07554.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006151649.07554.PeterHuewe@gmx.de>
X-Cookie: Keep on keepin' on.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 04:49:07PM +0200, Peter Hüwe wrote:

> So maybe even move the dependency up to SND_SOC_SH4_FSI 
> since both codecs rely on I2C?

No, while the two boards in mainline currently may need I2C obviously
other board designs with other control interfaces are possible so it
should be on the individual boards.
