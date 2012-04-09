Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2DITRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:17:08 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19749 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab2DITRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:17:07 -0400
Date: Mon, 9 Apr 2012 21:17:06 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jiri Kosina <jkosina@suse.cz>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Trivial] Delete trailing whitespace from
 sound/soc/codecs/wm8994.c
In-Reply-To: <alpine.LNX.2.00.1204090201160.24006@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1204092112320.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204090038270.11747@swampdragon.chaosbits.net> <alpine.LNX.2.00.1204090201160.24006@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Jiri Kosina wrote:

> On Mon, 9 Apr 2012, Jesper Juhl wrote:
> 
> > While reading through sound/soc/codecs/wm8994.c I noticed a fair
> > amount of trailing whitespace. This patch gets rid of it.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Jesper,
> 
> is it really worth it?

Maybe not. I just noticed it while I was reading through the file for 
other purposes and it annoyed me.


> The code should have been fixed before merging, 
> yes, but once it's there, such fixups tend to only make people angry 
> (because they have to do unnecessary extra steps during git blame).
> 

I think it's nice to get little things like this cleaned up, but at the 
same time I don't want to annoy other people.
I won't yell if you decide to just drop this patch.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

