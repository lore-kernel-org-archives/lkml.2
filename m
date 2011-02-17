Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1BQAFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:05:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:52493 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab1BQAFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:05:09 -0500
Date: Wed, 16 Feb 2011 16:03:19 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: Move runtime PM callbacks to usb_device_pm_ops
Message-ID: <20110217000319.GB6439@suse.de>
References: <201102170058.56503.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102170058.56503.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 12:58:56AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> USB defines usb_device_type pointing to usb_device_pm_ops that
> provides system-wide PM callbacks only and usb_bus_type pointing to
> usb_bus_pm_ops that provides runtime PM callbacks only.  However,
> the USB runtime PM callbacks may be defined in usb_device_pm_ops
> which makes it possible to drop usb_bus_pm_ops and will allow us
> to consolidate the handling of subsystems by the PM core code.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> Hi Greg,
> 
> Would you mind if I merged the following patch?  It is requisite for
> https://patchwork.kernel.org/patch/552411/ which I think is the right thing
> to do and people seem to generally agree with me.
> 
> Alan has seen it and says it is fine.

Looks great to me, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to it and take it through your tree.

thanks,

greg k-h
