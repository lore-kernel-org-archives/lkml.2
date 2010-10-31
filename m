Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0JaR33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:29:29 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:42407 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756351Ab0JaR30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:29:26 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] cs46xx memory management fixes for cs46xx_dsp_spos_create() - make sure we free and don't do pointless work.
Date: Sun, 31 Oct 2010 18:29:10 +0100
User-Agent: KMail/1.9.10
Cc: Benny =?utf-8?q?Sj=C3=B6strand?= <benny@hostmobility.com>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <alpine.LNX.2.00.1010292242080.24561@swampdragon.chaosbits.net> <201010301406.12961.linux@rainbow-software.org> <alpine.LNX.2.00.1010302143530.1572@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1010302143530.1572@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201010311829.13924.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 October 2010 21:44:33 Jesper Juhl wrote:
> On Sat, 30 Oct 2010, Ondrej Zary wrote:
> > On Saturday 30 October 2010 00:18:57 Benny Sjöstrand wrote:
> > > Hello again!
> > >
> > > Just doing a reply-all.
> > > It's has been many years since I did anything to the cs46xx driver, so
> > > I'm wondering
> > > if there's anyone out there still using a cs46xx sound card?
> > > I think the changes look's correct, but I can't test it, I do not have
> > > a cs46xx hardware anymore.
> >
> > Sure, there are many of these cards "out there". I just got a "new"
> > Terratec DMX Xfire 1024 (CS4624). I'll test the patch.
>
> Thanks a lot. Let me know how the test goes :-)

It works fine. Playing music right now.

-- 
Ondrej Zary
