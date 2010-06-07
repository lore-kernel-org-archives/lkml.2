Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab0FGVJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:09:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53366 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753117Ab0FGVJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:09:22 -0400
Date: Mon, 7 Jun 2010 17:09:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] [RFC] Save/restore MISC_ENABLE register
In-Reply-To: <201006072305.54829.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006071708040.18836-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Rafael J. Wysocki wrote:

> On Monday 07 June 2010, H. Peter Anvin wrote:
> > On 06/07/2010 11:51 AM, Ondrej Zary wrote:
> > > 
> > > Something like this?
> > > 
> > > Save/restore MISC_ENABLE register on suspend/resume.
> > > This fixes OOPS (invalid opcode) on resume from STR on Asus P4P800-VM, which
> > > wakes up with MWAIT disabled.
> > > 
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > 
> > 
> > Yes, that's a lot better.
> > 
> > I presume you have tested it.  Rafael, do you want to take this or should I?
> 
> I can take it.  Is it OK to add your ACK?

You might in addition want to note that this patch fixes Bugzilla 
#15385.

Alan Stern

