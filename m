Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab0DXE4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 00:56:32 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57341 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751048Ab0DXE4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 00:56:30 -0400
Date: Sat, 24 Apr 2010 06:56:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100424045626.GA7561@elf.ucw.cz>
References: <20100418115949.7b743898@infradead.org>
 <20100418120346.1b478410@infradead.org>
 <20100423052439.GB4829@ucw.cz>
 <20100423065248.3b0a98ab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423065248.3b0a98ab@infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Well, and now, if you do something like cat /dev/<your usb1.1 hdd> >
> > /dev/null, you'll keep cpu on max frequency. Not a problem for new
> > core i7, but probably big deal for athlon 64.
> 
> do you have facts not speculation for this? Does the athlon 64 really
> keep its voltage high during idle? That would surprise me greatly...

So... some old data. It is not exactly athlon 64 -- I don't have that
particular number for it -- but: (from my old notes):

evo n620c [63.3 Wh]
~~~~~~~~~~~~~~~~~
idle machine at 1.7GHz, min bl: 13.0 W
idle machine at 600MHz, min bl: 12.0 W

thinkpad x32 [52Wh]
~~~~~~~~~~~~
idle machine at 600MHz, min bl:         10 W
             at 1.8GHz:                 +6.6 W

hp nx5k [56.8Wh]
~~~~~~~
idle, min bl:                   19 W
      min bl, 1.4GHz:           22 W

...so yes, I kind of see a pattern there. And you should be able to
easily see the difference, too, if you took something from that era...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
