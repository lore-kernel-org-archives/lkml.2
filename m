Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0D0NBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:01:54 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37134 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754912Ab0D0NBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:01:49 -0400
Date: Tue, 27 Apr 2010 15:01:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Chan <mike@android.com>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       ?ric Piel <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       tglx@linutronix.de, davej@redhat.com, cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100427130139.GC3681@ucw.cz>
References: <20100418115949.7b743898@infradead.org>
 <4BCC147B.10708@tremplin-utc.net>
 <20100419064325.49cb3108@infradead.org>
 <201004201124.00326.trenn@suse.de>
 <m2x8bb80c381004261729r2e9b0df2q961c1d10430b2e1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2x8bb80c381004261729r2e9b0df2q961c1d10430b2e1f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > But I follow Eric and agree that if it costs that much, changing
> > above sounds sane.
> > Still, I could imagine some people might want to not raise freq on IO bound
> > process activity, therefore this should get another ondemand param, similar
> > to ignore_nice_load.
> >
> 
> I agree with Thomas here. Some of these assumptions on IO / FSB
> performance with cpu speed do not hold true on various ARM platforms.
> 
> Perhaps we could have a min_io_freq value? Which is the min speed for
> the cpu to run at for IO bound activity. In the original patch,
> min_io_freq = scaling_max_freq. For various arm devices I can happily
> set min_io_freq to the lowest cpu speed that satisfies bus speeds.

'satisfies bus speeds' == minimum cpu frequency where i/o works at all

 or

 == minimum cpu frequency where i/o works at full speed

?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
