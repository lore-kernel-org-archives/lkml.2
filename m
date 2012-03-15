Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031872Ab2COQuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:50:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58931 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031783Ab2COQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:49:56 -0400
Date: Thu, 15 Mar 2012 09:49:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: stable-3.0: s390 build breakage [was: Linux 3.0.24]
Message-ID: <20120315164953.GA10234@kroah.com>
References: <20120312203451.GA16773@kroah.com>
 <4F61C911.5010204@suse.cz>
 <20120315150947.GI7928@kroah.com>
 <20120315164255.GQ2264@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315164255.GQ2264@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 05:42:55PM +0100, Willy Tarreau wrote:
> On Thu, Mar 15, 2012 at 08:09:47AM -0700, Greg KH wrote:
> > On Thu, Mar 15, 2012 at 11:48:49AM +0100, Jiri Slaby wrote:
> > > On 03/12/2012 09:34 PM, Greg KH wrote:
> > > > I'm announcing the release of the 3.0.24 kernel.
> > > ...
> > > > Heiko Carstens (1): compat: fix compile breakage on s390
> > > 
> > > It looks like we need the same fix as for 2.6.32.59:
> > > arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
> > > arch/s390/kernel/setup.c:328: error: 'PSW32_ASC_PRIMARY' undeclared
> > > (first use in this function)
> > > arch/s390/kernel/setup.c:328: error: (Each undeclared identifier is
> > > reported only once
> > > arch/s390/kernel/setup.c:328: error: for each function it appears in.)
> > 
> > Ick.  What is the patch that should be applied here to resolve this?  I
> > don't remember seeing it go by, but I could have missed it.
> 
> Here's the one-liner Heiko sent to me against this issue.

Thanks, now queued up.

greg k-h
