Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab0E0Vmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:42:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34293 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757930Ab0E0Vms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:42:48 -0400
Date: Thu, 27 May 2010 22:49:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527224949.4d561091@lxorguk.ukuu.org.uk>
In-Reply-To: <201005272336.26643.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005271329460.3239-100000@iolanthe.rowland.org>
	<1274981871.27810.5650.camel@twins>
	<201005272336.26643.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 23:36:26 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday 27 May 2010, Peter Zijlstra wrote:
> > On Thu, 2010-05-27 at 13:32 -0400, Alan Stern wrote:
> > 
> > > On some platforms (like those with ACPI), deeper power-savings are
> > > available by using forced suspend than by using idle. 
> > 
> > Sounds like something that's fixable, doesn't it?
> 
> The fix would probably have to involve rewriting the ACPI spec.

We are on about the fourth version of ACPI already. ACPI evolves and
improves and extends. It's not an impossibility to sort that out if
everyone in the x86 OS world starts thinking 'How come their ARM platform
can do this'

We are also on at least the second suspend/resume model in Linux. The
first was 'isn't this APM stuff neat', the second is heavily oriented
around ACPI ideas. And we already have SoC people moving into the third
model and making it work on non-x6 ('suspend is not special').

I've not poked at the current desktop stuff enough to see if the
gnome-power-manager and friends handle pushing the suspend button with
dbus notifiers to apps. I guess it does.

Alan
