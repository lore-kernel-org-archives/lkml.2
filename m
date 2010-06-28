Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0F1TTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:19:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40624 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752077Ab0F1TTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:19:47 -0400
Date: Mon, 28 Jun 2010 15:19:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup events
 from being lost
In-Reply-To: <201006282101.54041.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006281517100.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Rafael J. Wysocki wrote:

> Below is the patch I'd like to add to suspend-2.6/linux-next.
> 
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Make it possible to avoid wakeup events from being lost
> 
> One of the arguments during the suspend blockers discussion was that
> the mainline kernel didn't contain any mechanisms making it possible
> to avoid losing wakeup events during system suspend.

I don't see anything more to complain about in the patch.  :-)

You probably should change the title and the first paragraph of the 
description to avoid saying that events can get lost.  Like:

PM: Make it possible to avoid races between wakeup and system sleep

Alan Stern

