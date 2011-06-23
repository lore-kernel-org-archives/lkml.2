Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab1FWSW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:22:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50895 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934317Ab1FWSWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:22:20 -0400
Date: Thu, 23 Jun 2011 14:22:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kevin Hilman <khilman@ti.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>
Subject: Re: [Update][PATCH 7/8] PM / Domains: System-wide transitions support
 for generic domains (v3)
In-Reply-To: <201106231941.09429.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106231421470.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Rafael J. Wysocki wrote:

> > It should say "system suspend" rather than "system sleep".
> 
> It says "system sleep" to distinguish between the state of the system
> ("system sleep") and the operation leading to that state ("system suspend").
> That terminology is used all over the document, so I don't think it's a good
> idea to change it just for this specific paragraph.
> 
> I agree that "suspend" should be used where it talks about starting, stopping
> etc.
> 
> > Then to drive the point home, the following sentence chould say 
> > something like this:
> > 
> > If that is the case and none of the situations listed above takes place
> > (in particular, if the system is waking up from suspend and not from
> > hibernation), it may be more efficient to leave the devices that had
> > been suspended before the system suspend began in the suspended state.
> 
> That's fine by me, except that I'd simply say "(in particular, if the system
> is not waking up from hibernation)".

Okay.

Alan Stern

