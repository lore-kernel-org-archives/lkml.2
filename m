Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1FGXrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:47:41 -0400
Received: from hofr.at ([212.69.189.236]:35452 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab1FGXrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:47:40 -0400
Date: Wed, 8 Jun 2011 01:38:09 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Remy Bohmer <linux@bohmer.net>,
        Armin Steinhoff <armin@steinhoff.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
Message-ID: <20110607233809.GB31794@opentech.at>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at> <alpine.LFD.2.02.1106071033350.11814@ionos> <4DEDF1F2.2080204@steinhoff.de> <1307439469.2322.235.camel@twins> <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com> <1307456080.2322.264.camel@twins> <alpine.LFD.2.02.1106071713570.11814@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1106071713570.11814@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jun 2011, Thomas Gleixner wrote:

> On Tue, 7 Jun 2011, Peter Zijlstra wrote:
> > On Tue, 2011-06-07 at 13:02 +0200, Remy Bohmer wrote:
> > > Well, I 100% agree that it must be under full userspace control to be
> > > able to set the priorities. But, the kernel default assumption of
> > > starting everything at 50 is wrong as well.
> > > Imagine the following situation:
> > > * Realtime application is running and has threads active in the range
> > > of prios 20 - 90.
> > > * Now bring up a network device, it immediately starts spamming the
> > > system at prio 50 _before_ you have the chance to set it below 20 by
> > > means of chrt.
> > > * RT behaviour is gone!
> > 
> > Good point I guess, Thomas should we default to 1 for everything?
> 
> No objections.

I think that splitting the range makes more sense - you are now potentially
reverting the argument brought up before.

"My drivers behave properly until I load any RT-task"

hofrat
