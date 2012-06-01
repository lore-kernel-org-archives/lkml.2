Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab2FANmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:42:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab2FANmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:42:04 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] add new NRP power meter USB device driver
Date: Fri, 1 Jun 2012 15:38:41 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        thomas.braunstorfinger@rohde-schwarz.com
References: <1338318858-24144-1-git-send-email-stefani@seibold.net> <201205311622.31537.oneukum@suse.de> <20120531143255.GA7069@kroah.com>
In-Reply-To: <20120531143255.GA7069@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206011538.41910.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 31. Mai 2012, 16:32:55 schrieb Greg KH:
> On Thu, May 31, 2012 at 04:22:31PM +0200, Oliver Neukum wrote:

> > It seems to specialised for this kind of IO. SPI over USB is closer to a generic
> > thing rather like sg or even a bus rather than an IIO device. Kernel space drivers
> > that use SPI might belong into IIO. The infrastructure itself not so much.
> 
> Wait, are you talking about the SPI we already support in the kernel?

Damn, one should watch one's spelling. SPI != SCPI
In the kernel we have SPI. This proposed driver is for SCPI.
The only relation they have is phonetic.

> Or something else?  This driver really looks like it wants to send to
> userspace "measurements" of something, which IIO is for.

As far as I can tell, it works by messages over a bus, rather like SCSI.
> 
> Anyway, as-is, this isn't acceptable, I'm sure we can all agree on that
> :)

Well, apart from the only ioctl I've seen far worse drivers.
The issue is not the driver as such, but whether and it what form it should exist.

	Regards
		Oliver
