Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab1DLSER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:04:17 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44232 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757477Ab1DLSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:04:16 -0400
Date: Tue, 12 Apr 2011 20:04:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Cyril Hrubis <metan@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com
Subject: Re: zaurus: mmcblk0: error -110
Message-ID: <20110412180414.GA26916@elf.ucw.cz>
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz>
 <BANLkTikNEJEwq4cfr6cmTcHqcRfyGLM6Ww@mail.gmail.com>
 <20110412152307.GD20815@atrey.karlin.mff.cuni.cz>
 <20110412155217.GA982@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412155217.GA982@atrey.karlin.mff.cuni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2011-04-12 17:52:17, Cyril Hrubis wrote:
> Hi!
> > > Which model do you have? And check the corresponding board file if
> > > card detect GPIO handling is doing right.
> > 
> > I've got spitz (SL-3200).
> > 
> > So I suppose the board file is arch/arm/mach-pxa/spitz.c, I'll have a look.
> 
> Hmm, besides cleanup by Marek Vasut there were no changes in the code. And it
> seems that it was just cleanup in spitz_card_pwr_ctrl().

With vanilla 2.6.38, I observe similar problem. MMC removal is not
detected; I get "error -110 whilst initalising SD card" on reinsert.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
