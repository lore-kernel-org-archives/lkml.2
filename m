Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0FETt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:49:59 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40131 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab0FETt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:49:58 -0400
Date: Sat, 5 Jun 2010 21:49:39 +0200
From: Florian Mickler <florian@mickler.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100605214939.49dd0ee0@schatten.dmk.lab>
In-Reply-To: <AANLkTil4DLUciWMVmCiiygS2Y1vLZu0Lnfys-w4q3L7W@mail.gmail.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<1275149418.4503.128.camel@mulgrave.site>
	<1275156734.1645.496.camel@laptop>
	<201005312314.12391.rjw@sisk.pl>
	<AANLkTil4DLUciWMVmCiiygS2Y1vLZu0Lnfys-w4q3L7W@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 20:16:33 +0300
Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Tue, Jun 1, 2010 at 12:14 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Do you realistically think that by hurting the _user_ you will make the
> > _developer_ write better code?  No, really.
> 
> As an application writer, if my users complain that their battery is
> being drained (as it happened), they stop using it, and other people
> see there are problems, so they stop using it, if people get angry
> about it they will vote it down.
> 
> New users will see it has low score; they will not install it. That's
> a network effect.
> 
> Having users is the quintessential reason people write code.
> 

That is nice. But how does it impact the problem that suspend blockers
solve? And why do suspend blockers interfere with that?

Cheers,
Flo
