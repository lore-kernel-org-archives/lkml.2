Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0FZSXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 14:23:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52067 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab0FZSXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 14:23:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Sat, 26 Jun 2010 20:21:42 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       mark gross <640e9920@gmail.com>, Florian Mickler <florian@mickler.org>,
       Neil Brown <neilb@suse.de>, linux-pci@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arve@smtp1.linux-foundation.org
References: <Pine.LNX.4.44L0.1006261258140.22018-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006261258140.22018-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006262021.42966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 26, 2010, Alan Stern wrote:
> On Sat, 26 Jun 2010, David Brownell wrote:
... 
> > > +        The
> > > /sys/power/wakeup_count file allows user space to avoid
> > > +        losing wakeup events
> > > when transitioning the system into a sleep
> > > +        state.  Reading
> 
> This could have been phrased better:  The /sys/power/wakeup_count file
> allows user space to put the system into a sleep state conditionally
> subject to the arrival of concurrent wakeup events, which will either
> block the sleep transition or cause it to fail.

I'll chage this in the final version.  Thanks!

Rafael
