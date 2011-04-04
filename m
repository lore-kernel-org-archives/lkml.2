Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1DDIFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 04:05:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45821 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753734Ab1DDIFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 04:05:03 -0400
Date: Mon, 4 Apr 2011 09:05:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Prchal =?utf-8?B?SmnFmcOt?= <jiri.prchal@aksignal.cz>
Cc: alsa-devel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: ASoc: new functions snd_soc_7_8_*
Message-ID: <20110404080502.GB22584@opensource.wolfsonmicro.com>
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au> <4D8B1AFD.5060508@aksignal.cz> <20110402082604.GE21737@sirena.org.uk> <4D997AF2.5040601@aksignal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D997AF2.5040601@aksignal.cz>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 10:01:54AM +0200, Prchal Jiří wrote:
> Hi,
> this is separated generic part of previous patch.
> It contains read and write functions for codecs which communicate via SPI with 7bit register address, 1 LSB is
> read/write and 2nd byte data.

Please folow the patch submission processs in SubmittingPatches,
especially with regard to the formatting of the mail containing the
patch.

Also note that as I previously said:

> > This won't apply against the current kernel and should be a separate

> diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/sound/soc/soc-cache.c
> linux-2.6.38-patch/sound/soc/soc-cache.c
> --- linux-2.6.38-vanilla/sound/soc/soc-cache.c	2011-03-15 02:20:32.000000000 +0100
> +++ linux-2.6.38-patch/sound/soc/soc-cache.c	2011-03-24 09:23:00.984373772 +0100

There have been some substantial updates to this code in current
kernels.
