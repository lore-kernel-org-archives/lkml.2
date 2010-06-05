Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab0FEUua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:50:30 -0400
Received: from ist.d-labs.de ([213.239.218.44]:52080 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab0FEUu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:50:29 -0400
Date: Sat, 5 Jun 2010 22:50:12 +0200
From: Florian Mickler <florian@mickler.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev?= =?ISO-8859-15?Q?=E5g?= 
	<arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100605225012.771332db@schatten.dmk.lab>
In-Reply-To: <AANLkTilhvUn3PfnHsJTNzhr59xrUyvGlFmnAOnub65sE@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
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
	<1275578881.27810.35995.camel@twins>
	<AANLkTinBg9W7zeomPbpGEDWkIsfxO9OfFUC0Kq7wafFb@mail.gmail.com>
	<20100605215604.68efc4e5@schatten.dmk.lab>
	<AANLkTilhvUn3PfnHsJTNzhr59xrUyvGlFmnAOnub65sE@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 23:06:03 +0300
Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Sat, Jun 5, 2010 at 10:56 PM, Florian Mickler <florian@mickler.org> wrote:
> > On Sat, 5 Jun 2010 20:30:40 +0300
> > Felipe Contreras <felipe.contreras@gmail.com> wrote:
> >> I don't think the suspend blockers solve much. A bad application will
> >> behave bad on any system. Suppose somebody decides to port Firefox to
> >> Android, and forgets to listen to the screen off event (bad on Android
> >> or Maemo), however, notices the application behaves very badly, so by
> >> googling finds these suspend blockers, and enables them all the time
> >> the application runs.
> >>
> >> When the user install the application, will be greeted by a warning
> >> "This application might break PM, do you want to enable suspend
> >> blockers?" (or whatever), as any typical user would do, will press Yes
> >> (whatever).
> >>
> >> We end up in exactly the same situation.
> >>
> > No. The application will show up in the suspend blocker stats and the
> > user will remember: "Oh, yes. There was a warning about that. Well I
> > think I'm going to file a bug there."
> 
> How would such stats be calculated? I presume at regular intervals you
> check which applications are holding suspend blockers and increase a
> counter.
> 
> How would you do that with the dynamic PM approach? At regular
> intervals you check for which applications are running (not idle).

IIRC, the patches discussed have debugging infrastructure in
them. The kernel does the accounting. 

> 
> > The only difference is, that with suspend blockers, he can than
> > dismiss the applications permission to block suspend and will not miss
> > his job interview the next day because his phones battery run
> > out. And also he can use the application to a certain extent.
> 
> So the difference is between removing the app, and making it run
> crappy. I don't think that's a strong argument in favor of suspend
> blockers.
> 
If you think a little about it, it is. Because if the app wouldn't be
usable at all, the bug wouldn't get fixed because the user wouldn't use
it. Or not?

Cheers,
Flo
