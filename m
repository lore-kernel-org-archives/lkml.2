Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0EaUrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:47:46 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60213 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0EaUro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:47:44 -0400
Date: Mon, 31 May 2010 22:47:32 +0200
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100531224732.2073828d@schatten.dmk.lab>
In-Reply-To: <20100531221219.212bf119@schatten.dmk.lab>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<1275030704.32462.11.camel@laptop>
	<AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
	<1275120618.27810.12699.camel@twins>
	<1275149418.4503.128.camel@mulgrave.site>
	<1275156734.1645.496.camel@laptop>
	<20100531221219.212bf119@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 22:12:19 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Sat, 29 May 2010 20:12:14 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > Why would you try to let buggy apps work as intended instead of break
> > them as hard as possible? Such policy promotes crappy code since people
> > get away with it.
> 
> If I have a simple shell script then I don't wanna jump through
> hoops just to please your fragile kernel. 

Also why should that code on one device kill my uptime and on the
other machine (my wall-plugged desktop) work just well? That doesn't
sound right.

Clearly opportunistic suspend is a workaround for battery-driven devices
and no general solution. But it is not specific to android. At least
not inherently. It could be useful for any embedded or mobile device
where you can clearly distinguish important functions from convenience
functions.

I really can't understand the whole _fundamental_ opposition to this
design choice. 

Cheers,
Flo
