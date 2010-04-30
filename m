Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab0D3SAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:00:54 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41472 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933484Ab0D3SAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:00:39 -0400
Date: Fri, 30 Apr 2010 20:00:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Subject: Re: 2.6.34-rc3 vs zaurus spitz: mistery solved
Message-ID: <20100430180028.GE24801@elf.ucw.cz>
References: <20100415180314.GC1443@ucw.cz>
 <x2qf17812d71004152325v26785671r23aafd9444614590@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x2qf17812d71004152325v26785671r23aafd9444614590@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-04-16 14:25:16, Eric Miao wrote:
> On Fri, Apr 16, 2010 at 2:03 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > For some reason, spitz will hang very early in boot with SLUB. With
> > SLOB, it boots fine.
> >
> 
> Weird, just wondering for what specific reason. Pavel, could you possibly
> paste the failure log if possible?

Ok, I tried a bit on -rc4, and it seems it went away. Problem solved
:-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
