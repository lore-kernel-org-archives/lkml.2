Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0KSTbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:31:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:32999 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756277Ab0KSTbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:31:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+GNkoSaaKGZsL6SB9n8DcMEoGGwZP0pqPcjzHgGG
	jNdwv3iMWoaKdX
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, mzxreary@0pointer.de, tytso@mit.edu,
        bgamari.foss@gmail.com, a.p.zijlstra@chello.nl, debiandev@gmail.com,
        alan@lxorguk.ukuu.org.uk, dhaval.giani@gmail.com, vgoyal@redhat.com,
        oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
In-Reply-To: <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com>
References: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu>
	 <20101119.082944.226775934.davem@davemloft.net>
	 <20101119163430.GA12353@tango.0pointer.de>
	 <20101119.084302.71115175.davem@davemloft.net>
	 <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 12:31:27 -0700
Message-ID: <1290195087.24581.27.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 09:51 -0800, Linus Torvalds wrote:

> And you really _can_ combine them. As mentioned, I'd be nervous about
> AIM benchmarks. I keep mentioning AIM, but that's because it has shown
> odd tty issues before. Back when the RT guys wanted to do that crazy
> blocking BKL thing (replace the spinlock with a semaphore), AIM7
> plummeted by 40%. And people were looking all over the place (file
> locking etc), and the tty layer was the biggest reason iirc.

If I were home, I'd have already checked out AIM7 and more, but I didn't
load laptop up with all my toys unfortunately.  (or fortunately, since
T130 ain't exactly a speed daemon)

	-Mike

