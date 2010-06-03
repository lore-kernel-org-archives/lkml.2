Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0FCP2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:28:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:36879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab0FCP2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:28:04 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100603161205.73a2b56d@schatten.dmk.lab>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	 <201005302202.39511.rjw@sisk.pl>
	 <AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	 <201005312347.24251.rjw@sisk.pl>
	 <AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	 <alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	 <AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	 <alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	 <AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
	 <1275471561.27810.30865.camel@twins>
	 <AANLkTilLmAb2c9fQwuguzWtjcHfuTZvPUTbUx7vuwFI6@mail.gmail.com>
	 <1275474088.27810.31000.camel@twins>
	 <20100602221309.6da754e7@schatten.dmk.lab>
	 <1275550802.27810.34863.camel@twins>
	 <20100603161205.73a2b56d@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 17:28:01 +0200
Message-ID: <1275578881.27810.35995.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 16:12 +0200, Florian Mickler wrote:
> On Thu, 03 Jun 2010 09:40:02 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Same for firefox, you can teach it to not render animated gifs and run
> > javascript for invisible tabs, and once the screen-saver kicks in,
> > nothing is visible (and with X telling apps their window is visible or
> > not it knows), so it should go idle all of its own.
> > 
> > Fix the friggin apps, don't kludge with freezing.
> 
> Of course programs should be as smart as possible. But that is an
> orthogonal problem.
> 
> Suppose firefox were fixed. It still needs to fetch my rss feeds every
> minute, because I'm sad if it doesn't. It just can't be fixed at the
> application level.

Sure it can, why would it need to fetch RSS feeds when the screen is off
and nobody could possible see the result? So you can stop the timer when
you know the window isn't visible or alternatively when the screensaver
is active, I think most desktops have notification of that as well.


