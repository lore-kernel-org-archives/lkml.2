Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2DIA30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 20:29:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab2DIA3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 20:29:25 -0400
Date: Mon, 9 Apr 2012 02:29:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Witten <mfwitten@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Trivial] Delete trailing whitespace from
 sound/soc/codecs/wm8994.c
In-Reply-To: <CAMOZ1BtxNhHxfbYfY+as7jpWHLO2P1QwCW_QpZbmQM+0xf1T=w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1204090228060.24006@pobox.suse.cz>
References: <alpine.LNX.2.00.1204090038270.11747@swampdragon.chaosbits.net> <alpine.LNX.2.00.1204090201160.24006@pobox.suse.cz> <CAMOZ1BtxNhHxfbYfY+as7jpWHLO2P1QwCW_QpZbmQM+0xf1T=w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Michael Witten wrote:

> >> While reading through sound/soc/codecs/wm8994.c I noticed a fair
> >> amount of trailing whitespace. This patch gets rid of it.
> >>
> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> >
> > Jesper,
> >
> > is it really worth it? The code should have been fixed before merging,
> > yes, but once it's there, such fixups tend to only make people angry
> > (because they have to do unnecessary extra steps during git blame).
> 
> If I may interject, I assume you mean that nobody wants to see the
> fact that somebody simply changed whitespace. However, the text of
> `git help blame' suggests that the `-w' flag obviates the issue:
> 
>   Ignore whitespace when comparing the parent's
>   version and the child’s to find where the lines
>   came from.
> 
> Of course, I've never used it, so I may be mistaken in my 
> interpretation.

That indeed does what it should do, but as it's not git default, then 
quitting git blame and reruning it with '-w' seems to be equally annoying 
to quitting git blame and reruning it with 'particular_commit~1"

-- 
Jiri Kosina
SUSE Labs
