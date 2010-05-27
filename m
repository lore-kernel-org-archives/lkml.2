Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab0E0VYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:24:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58842 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932444Ab0E0VY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:24:28 -0400
Date: Thu, 27 May 2010 17:24:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527210808.GB8865@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1005271723200.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:

> > > Doesn't help - I may be hit by the signal between the poll() unblocking 
> > > and me having the opportunity to call sigmask().
> > 
> > ppoll(). This is all existing solved stuff.
> 
> Isn't that the inverse of what we want? The application should default 
> to being SIGSTOPpable except in the case of it being in the process of 
> having a specific event delivered.

Would it help to divide the application into two processes, one of 
which receives events and the other does the drawing?

Alan Stern

