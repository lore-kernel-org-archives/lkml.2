Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab2DITM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:12:28 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19541 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2DITM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:12:27 -0400
Date: Mon, 9 Apr 2012 21:12:25 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: trivial@kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Trivial] Delete trailing whitespace from
 sound/soc/codecs/wm8994.c
In-Reply-To: <20120409103928.GB3182@opensource.wolfsonmicro.com>
Message-ID: <alpine.LNX.2.00.1204092109370.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204090038270.11747@swampdragon.chaosbits.net> <20120409103928.GB3182@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Mark Brown wrote:

> On Mon, Apr 09, 2012 at 12:40:32AM +0200, Jesper Juhl wrote:
> > While reading through sound/soc/codecs/wm8994.c I noticed a fair
> > amount of trailing whitespace. This patch gets rid of it.
> 
> Please try to make sure your changelog lines up with the subsysetem -
> this is especially important with trivial patches.
> 
Arrgh, sorry about that. I always forget (although not intentionally) to 
check if there's some special convention for a given subsystem :-(

I guess this would have been better:

ASoC: wm8994: Delete trailing whitespace


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

