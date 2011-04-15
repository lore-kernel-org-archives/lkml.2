Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab1DOViT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:38:19 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40826 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757123Ab1DOViS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:38:18 -0400
Date: Fri, 15 Apr 2011 23:38:17 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: Zaurus CF tests -- ok
Message-ID: <20110415213817.GC4420@atrey.karlin.mff.cuni.cz>
References: <20110415211822.GB21111@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415211822.GB21111@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> After getting _good_ power supply, I was able to untar and rm ltp tree
> 100 times so far. 2.6.38, ext3. (So metan no, I do not see any weird
> ext3 problems).

Hmm, I'm using original adapter, but who knows if it's okay to use...

> Another strange thing is... I see lots of duplicated keystrokes --
> like type "pavel" but machine understands "paavel". But it only seems
> to happen when I'm _not_ trying to debug it?!

That seems to be side effect of machine under load (it has gpio keyboard).

> (
> So... just because something needs 5V does not mean you should charge
> it from USB.
> 
> Yes, I'm talking about zaurus. I noticed that it crashed rather
> quickly when connected to USB power. (For example in tar/rm test).
> So I took multimeter, and there was 4.15..4.5V on USB :-(.
> 
> With power from USB extension cable, it crashes in <5 minutes. It
> seems to toggle charger a lot, as voltage on the cable is only
> 4.2..4.5V. I guess it is software problem in the charging code.
> )

The zaurus actually is AFAIK unable to run from battery when connected to the
external power, so weak power line may explain some of the strange behaviour.

-- 
metan
