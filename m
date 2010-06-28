Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0F1VVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:21:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57770 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab0F1VVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:21:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Mon, 28 Jun 2010 23:19:27 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <Pine.LNX.4.44L0.1006281517100.1977-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006281517100.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006282319.27758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 28, 2010, Alan Stern wrote:
> On Mon, 28 Jun 2010, Rafael J. Wysocki wrote:
> 
> > Below is the patch I'd like to add to suspend-2.6/linux-next.
> > 
> > Rafael
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Make it possible to avoid wakeup events from being lost
> > 
> > One of the arguments during the suspend blockers discussion was that
> > the mainline kernel didn't contain any mechanisms making it possible
> > to avoid losing wakeup events during system suspend.
> 
> I don't see anything more to complain about in the patch.  :-)

Great! :-)

> You probably should change the title and the first paragraph of the 
> description to avoid saying that events can get lost.  Like:
> 
> PM: Make it possible to avoid races between wakeup and system sleep

I will, thanks!

Rafael
