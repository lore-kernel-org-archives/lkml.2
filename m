Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab2AWV3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:29:48 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23788 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2AWV3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:29:47 -0500
Date: Mon, 23 Jan 2012 22:29:48 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Sound WM8958 DSP2: Use correct format string in dev_err()
 call
In-Reply-To: <20120123211107.GD26409@opensource.wolfsonmicro.com>
Message-ID: <alpine.LNX.2.00.1201232228510.8772@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201232113400.8772@swampdragon.chaosbits.net> <20120123211107.GD26409@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012, Mark Brown wrote:

> On Mon, Jan 23, 2012 at 09:15:48PM +0100, Jesper Juhl wrote:
> > To print a value of type size_t one should use %zd, not %d.
> 
> Applied, 

Thank you.

> thanks, but please do at least try to use a subject line in the
> style for the subsystem.

I'll try. I hope I hit closer to that mark with the other patch I just 
mailed you. :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

