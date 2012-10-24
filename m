Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935154Ab2JXPNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:13:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58730 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934146Ab2JXPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:13:19 -0400
Date: Wed, 24 Oct 2012 11:13:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: lockdep says circular locking since "tty: localise the lock"
In-Reply-To: <20121024142852.GE4368@breakpoint.cc>
Message-ID: <Pine.LNX.4.44L0.1210241112430.1481-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012, Sebastian Andrzej Siewior wrote:

> On Wed, Oct 17, 2012 at 09:20:35PM +0200, Sebastian Andrzej Siewior wrote:
> > With dummy_hcd and g_nokia (that is CONFIG_USB_GADGET=m,
> > CONFIG_USB_DUMMY_HCD=m, CONFIG_USB_G_NOKIA=m) I see a lockdep complaing
> > about a "circular locking dependency" after executing
> 
> ping? Or is it an obvious false positive?
> 
> Sebastian

Are you pinging yourself?  That's what it looks like...  :-)

Alan Stern

