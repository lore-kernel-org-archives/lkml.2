Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0IMRJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:09:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:51320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab0IMRJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:09:32 -0400
Date: Mon, 13 Sep 2010 10:06:56 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, Phil Dibowitz <phil@ipom.com>,
        stable@kernel.org, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device
 events loss
Message-ID: <20100913170656.GA9122@suse.de>
References: <Pine.LNX.4.44L0.1009131219490.1315-100000@iolanthe.rowland.org>
 <4C8E594B.6080100@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8E594B.6080100@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 07:03:07PM +0200, Jiri Slaby wrote:
> On 09/13/2010 06:24 PM, Alan Stern wrote:
> > Jiri, as a workaround for people using the current 3.6.34.stable, you
> > can ask them to do:
> > 
> > 	echo on >/sys/bus/usb/devices/.../power/level
> > 
> > with the "..." filled in appropriately.
> 
> Yeah, the people are using that already. (Actually, they attached a udev
> script to do that automatically.) Or usbcore.autosuspend=-1 is an easier
> workaround (but disables autosuspend completely, indeed).

I've now released 2.6.34.7 with this patch reverted so all should be
good now.

thanks,

greg k-h
