Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1DGQis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:38:48 -0400
Received: from kroah.org ([198.145.64.141]:48571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab1DGQir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:38:47 -0400
Date: Thu, 7 Apr 2011 09:39:48 -0700
From: Greg KH <greg@kroah.com>
To: Gottfried Haider <gottfried.haider@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [Regression] USB tethering does not work anymore in 2.6.29-rc2
 (rndis_host, does not receive DHCP offer anymore)
Message-ID: <20110407163948.GD31060@kroah.com>
References: <BANLkTim8anqNv4MEaxCTyC8HyOZp2x=ixQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim8anqNv4MEaxCTyC8HyOZp2x=ixQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 04:11:27AM +0200, Gottfried Haider wrote:
> Hello,
> 
> I am using an Android phone connected over USB to connect to the
> internet. Something in -rc2 broke this, as I am not getting
> connections through NetworkManager anymore (it doesn't receive a
> DHCPOFFER anymore and times out).
> 
> This does work on the -rc1 kernel and is 100% reproducible here (same
> USB port, rebooting the phone between tries).

Any chance you can run 'git bisect' to narrow down the problem to the
offending change?

thanks,

greg k-h
