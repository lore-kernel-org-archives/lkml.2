Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab1DEOm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:42:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41210 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752747Ab1DEOmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:42:24 -0400
Date: Tue, 5 Apr 2011 10:42:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oncaphillis <oncaphillis@snafu.de>
cc: Xiaofan Chen <xiaofanc@gmail.com>, <libusb-devel@lists.sourceforge.net>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Libusb-devel] Kernel bug message and missing data on
 libusb_interrupt_transfer
In-Reply-To: <4D9B2575.4030205@snafu.de>
Message-ID: <Pine.LNX.4.44L0.1104051040440.1972-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011, Oncaphillis wrote:

> On 04/05/2011 04:13 PM, Alan Stern wrote:
> > On Tue, 5 Apr 2011, Oncaphillis wrote:
> >
> >> Now I get
> >>
> >> <snip>
> >> ------------[ cut here ]------------
> >> kernel BUG at mm/slub.c:2808!
> >> invalid opcode: 0000 [#2] SMP
> > Can you duplicate this using either a 2.6.37 or 2.6.38 kernel?
> >
> > Alan Stern
> >
> The highest kernel version we've tried (as far as i remember) was the
> 2.6.36. Have there been issues which might have been solved betwen 36 
> and 3(7|8) ?

I don't know.  But the core kernel developers always want to hear about
problems reported against the most recent version possible.  If you
could test 2.6.39-rc1 (or -rc2, which should be released in a day or
so), that would be even better.

> I'll give it a try.

Thanks.

Alan Stern

