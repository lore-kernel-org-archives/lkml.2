Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2EaKUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:20:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab2EaKUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:20:30 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] add new NRP power meter USB device driver
Date: Thu, 31 May 2012 12:17:11 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        thomas.braunstorfinger@rohde-schwarz.com
References: <1338318858-24144-1-git-send-email-stefani@seibold.net> <1338454041.6454.67.camel@wall-e> <20120531095304.GA3884@kroah.com>
In-Reply-To: <20120531095304.GA3884@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205311217.11692.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 31. Mai 2012, 11:53:04 schrieb Greg KH:
> > So it is a chicken and egg problem. A lot of software is now out with
> > depends on this driver and a lot of embedded development environments
> > doesn't provide libudev, libsysfs und libusb. It will also increase the
> > size of the image and adds additional dependencies to the application.
> 
> You don't need any of those libraries to do this.  What's wrong with
> using "raw" usbfs interactions?

SPI is not limited to USB. If we can get a unified subsystem then the
drivers need to be in kernel space, as some hardware does not allow
a solution in user space.

	Regards
		Oliver
