Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1KHBFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:05:17 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51607 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab1KHBFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:05:16 -0500
X-Sasl-enc: i/nzi/UFXVRZ2a+3beVMkj8ScQ5ZpUdClrPVQh/GWzP8 1320714315
Date: Mon, 7 Nov 2011 17:02:44 -0800
From: Greg KH <greg@kroah.com>
To: Carla Sella <carla.sella@gmail.com>
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com
Subject: Re: BUG:  attaching a usb based music player to a usb port  does not
 open banshee
Message-ID: <20111108010244.GA16800@kroah.com>
References: <4EB5401B.4080708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB5401B.4080708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 02:54:35PM +0100, Carla Sella wrote:
> Hello,
> I'm reporting upstream a bug I already have reported in launchpad for
> Ubuntu.
> When I attach a usb based music player to a usb port, banshee music
> player does not open, but nautilus opens instead, when I used to use 
> Ubuntu Natty inserting the music player opened banshee.
> All the files in the music player are displayed in nautilus, if I click
> on a music file, banshee then opens.

That's really not a kernel bug at all, but rather a distro-specific
issue, not much we can do here to help you with that, sorry.

greg k-h
