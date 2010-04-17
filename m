Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0DQTA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:00:56 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37619 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753816Ab0DQTAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:00:55 -0400
Date: Sat, 17 Apr 2010 21:00:53 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Subject: Re: 2.6.34-rc3 vs zaurus spitz: mistery solved
Message-ID: <20100417190053.GA4611@atrey.karlin.mff.cuni.cz>
References: <20100415180314.GC1443@ucw.cz> <x2qf17812d71004152325v26785671r23aafd9444614590@mail.gmail.com> <20100416201245.GB13350@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416201245.GB13350@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > For some reason, spitz will hang very early in boot with SLUB. With
> > > SLOB, it boots fine.
> > >
> > 
> > Weird, just wondering for what specific reason. Pavel, could you possibly
> > paste the failure log if possible?
> 
> Investigating... So far it seems that either it was fixed in -rc4 or
> that slub debugging options cause the problem.

rc4 is working for me, so it looks like this was fixed, or at least works again
now.

-- 
metan
