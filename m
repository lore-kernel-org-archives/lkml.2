Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030631Ab2I2BxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 21:53:15 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56994 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759383Ab2I2BxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 21:53:12 -0400
Date: Fri, 28 Sep 2012 21:53:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Joe Perches <joe@perches.com>
cc: Andy Whitcroft <apw@canonical.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Probable false positive in checkpatch
In-Reply-To: <1348865957.14262.46.camel@joe-AO722>
Message-ID: <Pine.LNX.4.44L0.1209282151320.18180-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Joe Perches wrote:

> On Fri, 2012-09-28 at 15:50 -0400, Alan Stern wrote:
> > Here's what I just got from checkpatch:
> > 
> > ERROR: space prohibited after that '-' (ctx:BxW)
> > #22: FILE: drivers/usb/host/ehci-sched.c:1419:
> > +                       start += (next - start + period - 1) & (- period);
> >                                                                 ^
> > This seems unlikely to be a real style violation.  Or if it is, maybe 
> > it shouldn't be.  After all, "(0 - period)" would be okay.
> 
> 2c: I think the recommendation is proper and correct.

I just looked in CodingStyle, and sure enough, there it is in section 
3.1.  The complaint is hereby withdrawn.

Alan Stern

