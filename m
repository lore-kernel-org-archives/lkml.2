Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2BLWCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 17:02:30 -0500
Received: from netrider.rowland.org ([192.131.102.5]:60836 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753438Ab2BLWC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 17:02:29 -0500
Date: Sun, 12 Feb 2012 17:02:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in disk event polling
In-Reply-To: <201202122226.22082.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1202121701380.22346-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Feb 2012, Rafael J. Wysocki wrote:

> > > Given the stuff async is used for, maybe just make all async execution
> > > freezable?
> > 
> > That probably won't work.  What if a driver relies on async thread
> > execution to carry out its I/O?
> 
> Well, we use async in the suspend code itself. :-)

Yeah, I remembered that after sending the email message.

Alan Stern

