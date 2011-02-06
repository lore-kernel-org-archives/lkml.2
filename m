Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1BFP30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:29:26 -0500
Received: from netrider.rowland.org ([192.131.102.5]:55880 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752164Ab1BFP3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:29:25 -0500
Date: Sun, 6 Feb 2011 10:29:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] PM: Do not create wakeup sysfs files for devices that
 cannot wake up (v2)
In-Reply-To: <201102061519.11360.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1102061024150.20379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011, Rafael J. Wysocki wrote:

> Hi,
> 
> Below is the next version of the patch changing the PM core to only create
> wakeup sysfs files for devices that are wakeup-capable.  It contains a change
> in drivers/usb/core/hub.c that should avoid the problem described in the thread
> at https://lkml.org/lkml/2011/2/5/108 , but I'm not 100% it's the right
> approach.  Please have a look.

Yes, that's right -- in fact, it's exactly the same as what I was going
to do.  Of course, it should be separated out into a separate patch, to
be applied before the other wakeup changes.

Alan Stern

