Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2BPW00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:26:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49007 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754540Ab2BPW0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:26:25 -0500
Date: Thu, 16 Feb 2012 17:26:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Dave Jones <davej@redhat.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <esandeen@redhat.com>
Subject: Re: [linux-pm] Corrupted files after suspend to disk
In-Reply-To: <201202162251.47063.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1202161722310.1150-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012, Rafael J. Wysocki wrote:

> > FWIW, we've been seeing a number of hard to diagnose failures
> > with suspend to disk for the last few releases in Fedora.
> > Eric Sandeen has been chasing https://bugzilla.redhat.com/show_bug.cgi?id=744275
> > for a while, but there's no smoking gun that really explains what's
> > getting into these states. Further complicating things, is that it
> > doesn't seem to be 100% reproducable.
> 
> I wonder if that's reproducible with the filesystems freezing patch I posted
> some time ago (it will need some rebasing to apply to the current mainline or
> 3.2.y).
> 
> I also thing that this problem discovered by Alan Stern may be involved:
> 
> http://marc.info/?l=linux-pm&m=132940331030253&w=4

Probably not, unless the filesystems in question are on a USB drive.  
Still, if anyone wants to test it, there's a patch here:

	http://marc.info/?l=linux-pm&m=132941053601190&w=4

Alan Stern

