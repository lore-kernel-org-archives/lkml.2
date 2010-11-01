Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab0KASeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:34:06 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19985 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab0KASeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:34:04 -0400
Date: Mon, 1 Nov 2010 19:23:32 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Takashi Iwai <tiwai@suse.de>
cc: Ondrej Zary <linux@rainbow-software.org>,
        =?ISO-8859-15?Q?Benny_Sj=F6strand?= <benny@hostmobility.com>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] cs46xx memory management fixes for cs46xx_dsp_spos_create()
 - make sure we free and don't do pointless work.
In-Reply-To: <s5h39rl2xjm.wl%tiwai@suse.de>
Message-ID: <alpine.LNX.2.00.1011011922460.9616@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010292242080.24561@swampdragon.chaosbits.net> <201010301406.12961.linux@rainbow-software.org> <alpine.LNX.2.00.1010302143530.1572@swampdragon.chaosbits.net> <201010311829.13924.linux@rainbow-software.org>
 <s5h39rl2xjm.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2090847303-1288635812=:9616"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2090847303-1288635812=:9616
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 1 Nov 2010, Takashi Iwai wrote:

> At Sun, 31 Oct 2010 18:29:10 +0100,
> Ondrej Zary wrote:
> > 
> > On Saturday 30 October 2010 21:44:33 Jesper Juhl wrote:
> > > On Sat, 30 Oct 2010, Ondrej Zary wrote:
> > > > On Saturday 30 October 2010 00:18:57 Benny Sjöstrand wrote:
> > > > > Hello again!
> > > > >
> > > > > Just doing a reply-all.
> > > > > It's has been many years since I did anything to the cs46xx driver, so
> > > > > I'm wondering
> > > > > if there's anyone out there still using a cs46xx sound card?
> > > > > I think the changes look's correct, but I can't test it, I do not have
> > > > > a cs46xx hardware anymore.
> > > >
> > > > Sure, there are many of these cards "out there". I just got a "new"
> > > > Terratec DMX Xfire 1024 (CS4624). I'll test the patch.
> > >
> > > Thanks a lot. Let me know how the test goes :-)
> > 
> > It works fine. Playing music right now.
> 
> Great.  I applied the patch now.
> 
Thanks Takashi and thank you for testing Ondrej :-)

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

--8323328-2090847303-1288635812=:9616--
