Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0D0VeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:34:14 -0400
Received: from kroah.org ([198.145.64.141]:44397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159Ab0D0VeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:34:12 -0400
Date: Tue, 27 Apr 2010 14:33:59 -0700
From: Greg KH <greg@kroah.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [RFC] ehci: Disable wake on overcurrent (WKOC_E)
 and disconnect (WKDISC_E)
Message-ID: <20100427213359.GA29696@kroah.com>
References: <Pine.LNX.4.44L0.1004271509450.1850-100000@iolanthe.rowland.org>
 <201004272246.51494.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004272246.51494.linux@rainbow-software.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 10:46:48PM +0200, Ondrej Zary wrote:
> > Why would you want to change the jumper settings?  Host controllers are
> > _supposed_ to supply 5V power during system suspend.
> 
> Maybe because I don't want all my USB devices to be powered when the system is 
> turned off. I doubt that laptop in suspend-to-RAM (on battery) provides power 
> to USB ports.

On the contrary, it does.  Some of us use this mode to charge devices :)

thanks,

greg k-h
