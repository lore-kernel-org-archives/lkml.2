Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab1EZOKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:10:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41121 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752265Ab1EZOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:10:10 -0400
Date: Thu, 26 May 2011 22:10:02 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [Patch][Trivial] sound, soc, codec, WM8915: Remove duplicate
 linux/delay.h inclusion.
Message-ID: <20110526141001.GE15094@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1105261028060.17400@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1105261028060.17400@swampdragon.chaosbits.net>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:32:41AM +0200, Jesper Juhl wrote:
> It's enough to include linux/delay.h just once in 
> sound/soc/codecs/wm8915.c, so remove the duplicate.

Applied.  Please od try to use sensible subject lines for your patches -
it makes them much easier to apply.
