Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1BQASp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:18:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56004 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1BQASm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:18:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] USB: Move runtime PM callbacks to usb_device_pm_ops
Date: Thu, 17 Feb 2011 01:18:13 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <201102170058.56503.rjw@sisk.pl> <20110217000319.GB6439@suse.de>
In-Reply-To: <20110217000319.GB6439@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102170118.13294.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 17, 2011, Greg KH wrote:
> On Thu, Feb 17, 2011 at 12:58:56AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > USB defines usb_device_type pointing to usb_device_pm_ops that
> > provides system-wide PM callbacks only and usb_bus_type pointing to
> > usb_bus_pm_ops that provides runtime PM callbacks only.  However,
> > the USB runtime PM callbacks may be defined in usb_device_pm_ops
> > which makes it possible to drop usb_bus_pm_ops and will allow us
> > to consolidate the handling of subsystems by the PM core code.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> > Hi Greg,
> > 
> > Would you mind if I merged the following patch?  It is requisite for
> > https://patchwork.kernel.org/patch/552411/ which I think is the right thing
> > to do and people seem to generally agree with me.
> > 
> > Alan has seen it and says it is fine.
> 
> Looks great to me, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to it and take it through your tree.

I will, thanks!

Rafael
