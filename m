Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1DPIfJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:35:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44345 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751984Ab1DPIfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:35:07 -0400
Date: Sat, 16 Apr 2011 09:41:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Cyril Hrubis <metan@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: Zaurus CF tests -- ok
Message-ID: <20110416074134.GA26440@ucw.cz>
References: <20110415211822.GB21111@atrey.karlin.mff.cuni.cz>
 <20110415213817.GC4420@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415213817.GC4420@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > After getting _good_ power supply, I was able to untar and rm ltp tree
> > 100 times so far. 2.6.38, ext3. (So metan no, I do not see any weird
> > ext3 problems).
> 
> Hmm, I'm using original adapter, but who knows if it's okay to use...

It probably is...

> > Another strange thing is... I see lots of duplicated keystrokes --
> > like type "pavel" but machine understands "paavel". But it only seems
> > to happen when I'm _not_ trying to debug it?!
> 
> That seems to be side effect of machine under load (it has gpio keyboard).

ouch. original corgi_kbd driver used timers, new one uses threads --
more affected by scheduling. I'm not even sure if the worker thread it
uses runs at elevated priority...

> > With power from USB extension cable, it crashes in <5 minutes. It
> > seems to toggle charger a lot, as voltage on the cable is only
> > 4.2..4.5V. I guess it is software problem in the charging code.
> > )
> 
> The zaurus actually is AFAIK unable to run from battery when connected to the
> external power, so weak power line may explain some of the strange behaviour.

?? IIRC Stanislav told me that hardware will always run off whatever
is available...?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
