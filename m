Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0HXVJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:09:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47593 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755496Ab0HXVJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:09:04 -0400
Date: Tue, 24 Aug 2010 17:09:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Runtime PM and the block layer
In-Reply-To: <4C74273B.4000308@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1008241708050.1652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Jens Axboe wrote:

> > I see.  You're suggesting we add a new "power_mode" or "queue_idle"  
> > callback to the request_queue struct, and make the block layer invoke
> > this callback whenever a request completes and there are no other
> > requests pending or in flight.  Right?  And similarly, invoke the
> > callback (with a different argument) when the first request gets added
> > to an otherwise empty queue.
> > 
> > That would suit my needs.
> 
> Yep, that is what I'm suggesting.

All right, I'll work on this and get back to you when I need more help.  
Thanks for the advice.

Alan Stern

