Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2HCSUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:20:07 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:42844 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2HCSUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:20:05 -0400
Date: Fri, 3 Aug 2012 14:19:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Chris Friesen <chris.friesen@genband.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE("GPL")??
Message-ID: <20120803181959.GC8463@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mark Hounschell <dmarkh@cfl.rr.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Chris Friesen <chris.friesen@genband.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <50199E91.5040308@cfl.rr.com>
 <20120801224342.5b90747f@pyramind.ukuu.org.uk>
 <501A704E.2000301@cfl.rr.com>
 <501B5D51.5030307@genband.com>
 <501BBE45.8060309@cfl.rr.com>
 <20120803142923.311c70b6@pyramind.ukuu.org.uk>
 <501BDBEE.60305@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501BDBEE.60305@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 10:10:54AM -0400, Mark Hounschell wrote:
> On 08/03/2012 09:29 AM, Alan Cox wrote:
> >>assumption that that actually meant they were NOT using GPL symbols.
> >
> >All symbols in the Linux kernel are to GPL code and all linking dynamic
> >or otherwise is subject to the GPL licence. That is you need to be able
> >to show anything non-free linked with it such as a kernel module is not a
> >derivative work.
> 
> Why then is there EXPORT_SYMBOL_GPL and EXPORT_SYMBOL? As long as
> you have them both, one can and will, assume that what you say above
> is not the intent.

The question of whether or not a program or driver which dynamically
links with GPL'ed code becomes a derivitive work of the GPL'ed code is
a complex one.  This is especially true if you use GPL'ed header files
that include inline functions or complex CPP macros.  Whether or not
this is actually the case may very well depend on your local legal
jourisdiction, and it's ultimately something where no one on this list
can give you legal advice.

If the drivers are distributed under the GPL, then it's obviously
safe.  If they distributed under some other license, you will need to
consult with your lawyers.

> Again, our Linux kernel drivers are and always were GPL and at least
> partly so because of EXPORT_SYMBOL_GPL.

Well, that's obviously something that we would all prefer, since
avoiding needing to talk to lawyers is always a Good Thing (tm).
<grin>

One of the more important reasons is that this removes one of the key
barriers towards getting the driver included in the kernel sources,
which can be a huge advantage from a code maintenance point of view,
and given that more embedded Linux device manufacturers are more
conscious of their obligations under the GPL, it can be an advantage
during the RFP/hardware selection process.

						- Ted
