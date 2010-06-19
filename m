Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0FSBgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 21:36:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60149 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754407Ab0FSBgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 21:36:16 -0400
Date: Sat, 19 Jun 2010 02:36:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stuart Longland <redhatter@gentoo.org>
Cc: ALSA Development List <alsa-devel@alsa-project.org>,
       Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Fix overflow bug in SOC_DOUBLE_R_SX_TLV
Message-ID: <20100619013629.GA2974@opensource.wolfsonmicro.com>
References: <20100618023810.GS7759@www.longlandclan.yi.org>
 <1276829770-31557-1-git-send-email-redhatter@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276829770-31557-1-git-send-email-redhatter@gentoo.org>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 12:56:10PM +1000, Stuart Longland wrote:
> When SX_TLV widgets are read, if the gain is set to a value below 0dB,
> the mixer control is erroniously read as being at maximum volume.

Applied, thanks.

BTW, you might want to have a look at the CCs - you probably don't need
to CCing the ARM list for ASoC patches that aren't ARM specific, for
example.
