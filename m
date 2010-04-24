Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0DXPt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 11:49:57 -0400
Received: from kroah.org ([198.145.64.141]:55502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab0DXPt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 11:49:56 -0400
Date: Sat, 24 Apr 2010 08:49:51 -0700
From: Greg KH <greg@kroah.com>
To: Eric Lescouet <Eric.Lescouet@virtuallogix.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: make hub.h, hcd.h public (drivers
	dependency), linux-2.6.34-rc5
Message-ID: <20100424154951.GA11919@kroah.com>
References: <1272121713.23655.63.camel@localhost> <20100424153501.GA11465@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100424153501.GA11465@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 08:35:01AM -0700, Greg KH wrote:
> On Sat, Apr 24, 2010 at 05:08:33PM +0200, Eric Lescouet wrote:
> > The usbcore headers:hcd.h and hub.h are shared between usbcore,
> > HCDs and a couple of other drivers (e.g. USBIP modules).
> > So, it makes sense to move them into a more public location and
> > to cleanup dependency of those modules on kernel internal headers.
> > Both are moved into include/linux/usb/
> 
> Just move one at a time.  Patches should do one thing only.  So this
> should be at least 2 patches.
> 
> And I thought you were going to rename hub.h to ch11.h instead?

Oops, I now see patch 2 :)

Anyway, how about 3 patches here?  Your last one is fine, but make the
first one into 2 different ones?  One that does hcd.h and then one that
does hub.h.

thanks,

greg k-h
