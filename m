Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2EOO0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:26:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45535 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757431Ab2EOO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:26:45 -0400
Date: Tue, 15 May 2012 10:26:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bojan Smojver <bojan@rexursive.com>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, <bp@alien8.de>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
In-Reply-To: <1337039996.1628.9.camel@shrek.rexursive.com>
Message-ID: <Pine.LNX.4.44L0.1205151026210.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Bojan Smojver wrote:

> Alan/Srivatsa,
> 
> Coming back to the explanation of how this whole thing works, it would
> seem that at the point of image writing all devices are fully functional
> (not just some, as I mistakenly believed). However, the processes are
> supposed to be already frozen, right? Calling suspend_prepare(), which
> will essentially try to freeze the processes and kernel threads, seems
> like the wrong thing to do.
> 
> Did you guys mean that we should be calling
> pm_notifier_call_chain(PM_SUSPEND_PREPARE) only here?

It looks like you've got this all figured out now.

Alan Stern

