Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab1DMRK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:10:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab1DMRK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=jnHVgvw9Cw0RF4Y1o9nkjyWgxVLpuHH1wlFdMdHXgpEA6+TAnsLpwTwYaRT6xcN00O
         sNLHNDpWxj+vrYkeffQG9IskBMURCANG1uZy7SFDoeieyL5W3WF5GLZryRhwIShJOTTS
         OGTfH2xX1OQklkx1+3aZ7djS0lhwEY5kKwjW8=
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: zaurus: mmcblk0: error -110
Date: Wed, 13 Apr 2011 19:10:53 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-1-amd64; KDE/4.6.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Cyril Hrubis <metan@ucw.cz>,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz> <20110412155217.GA982@atrey.karlin.mff.cuni.cz> <20110412180414.GA26916@elf.ucw.cz>
In-Reply-To: <20110412180414.GA26916@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104131910.53824.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 12, 2011 08:04:14 PM Pavel Machek wrote:
> On Tue 2011-04-12 17:52:17, Cyril Hrubis wrote:
> > Hi!
> > 
> > > > Which model do you have? And check the corresponding board file if
> > > > card detect GPIO handling is doing right.
> > > 
> > > I've got spitz (SL-3200).
> > > 
> > > So I suppose the board file is arch/arm/mach-pxa/spitz.c, I'll have a
> > > look.
> > 
> > Hmm, besides cleanup by Marek Vasut there were no changes in the code.
> > And it seems that it was just cleanup in spitz_card_pwr_ctrl().
> 
> With vanilla 2.6.38, I observe similar problem. MMC removal is not
> detected; I get "error -110 whilst initalising SD card" on reinsert.
> 									Pavel

I don't observe this problem with my tree (.38-rc8+). I'll have to check 
properly though. (On SL-C1000)

Cyril, can you bisect between .37 and .38? I suspect some change in mmc subsys.

Cheers
