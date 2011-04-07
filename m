Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1DGQk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:40:56 -0400
Received: from kroah.org ([198.145.64.141]:48577 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab1DGQkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:40:55 -0400
Date: Thu, 7 Apr 2011 09:42:02 -0700
From: Greg KH <greg@kroah.com>
To: Gottfried Haider <gottfried.haider@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [Regression] USB tethering does not work anymore in 2.6.29-rc2
 (rndis_host, does not receive DHCP offer anymore)
Message-ID: <20110407164202.GA31291@kroah.com>
References: <BANLkTim8anqNv4MEaxCTyC8HyOZp2x=ixQ@mail.gmail.com>
 <20110407163948.GD31060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407163948.GD31060@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 09:39:48AM -0700, Greg KH wrote:
> On Thu, Apr 07, 2011 at 04:11:27AM +0200, Gottfried Haider wrote:
> > Hello,
> > 
> > I am using an Android phone connected over USB to connect to the
> > internet. Something in -rc2 broke this, as I am not getting
> > connections through NetworkManager anymore (it doesn't receive a
> > DHCPOFFER anymore and times out).
> > 
> > This does work on the -rc1 kernel and is 100% reproducible here (same
> > USB port, rebooting the phone between tries).
> 
> Any chance you can run 'git bisect' to narrow down the problem to the
> offending change?

I just tested this myself and can confirm it doesn't work, but I will
not have the time to run 'git bisect' until next week as I'm on the road
:(

thanks,

greg k-h
