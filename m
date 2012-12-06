Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2LFMXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:23:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:51664 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2LFMXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:23:44 -0500
Date: Thu, 6 Dec 2012 13:23:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Edward Donovan <edward.donovan@numble.net>
cc: "Wang, Warner" <warner.wang@hp.com>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: need help on a DEADLOCK problem related to function
 try_one_irq()
In-Reply-To: <CADdbW+F0aO3Y1F+-Ywksmfy5J5xmRc+euwEO9B2frA=EfrRfGg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1212061322060.2701@ionos>
References: <DAE2ECFDBE54434BA3014E0CC0F2A1E87700075B@G4W3211.americas.hpqcorp.net> <alpine.LFD.2.02.1211221120580.2701@ionos> <alpine.LFD.2.02.1211231008060.2701@ionos> <DAE2ECFDBE54434BA3014E0CC0F2A1E877000F52@G4W3211.americas.hpqcorp.net>
 <CADdbW+F0aO3Y1F+-Ywksmfy5J5xmRc+euwEO9B2frA=EfrRfGg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed,

On Thu, 6 Dec 2012, Edward Donovan wrote:
> So, let me try to confirm some things now, so I can learn as I go.  To
> spell out what's in the new patch:
> 
> The later line,
> 
>   action = desc->action;
> 
> should have been this all along?
> 
>   action = action->next;

Yes. My bad :(
 
> And with that fixed, the other test can go.  Which is good, now,
> because it was creating locking problems for you.
> 
> Ok, thanks for bearing with me.   I'll repeat the test here, some
> more, but they've generally behaved consistently and probably will
> keep showing the same.
> 
> I might as well add that I would happily ship one of these computers,
> with a reliably spurious interrupt, to Thomas in Germany. if that
> would help for testing.

I'm always happy to have machines which expose strange symptoms.

Thanks,

	tglx
