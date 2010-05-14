Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0ENUah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:30:37 -0400
Received: from kroah.org ([198.145.64.141]:40798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab0ENUaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:30:35 -0400
Date: Fri, 14 May 2010 13:16:04 -0700
From: Greg KH <greg@kroah.com>
To: Adam Latham <adam.latham@unisontorbay.org.uk>
Cc: gregkh@suse.de, Andrew.Elwell@gmail.com, mithlesh@linsyssoft.com,
       svenne@krap.dk, jkosina@suse.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: wlan-ng: hfa384x_usb.c patch: Fix Whitespace issues
Message-ID: <20100514201604.GA23006@kroah.com>
References: <1273518686.2786.3.camel@ubuntu.ubuntu-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273518686.2786.3.camel@ubuntu.ubuntu-domain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 08:11:26PM +0100, Adam Latham wrote:
> >From bd66eecfcc4fa4c0340f55d73dd4ada3a5e0b00a Mon Sep 17 00:00:00 2001
> From: Adam Latham <adam.latham@unisontorbay.org.uk>
> Date: Mon, 10 May 2010 19:59:39 +0100
> Subject: [PATCH] Staging: wlan-ng: fix whitespace errors in hfa384x_usb.c
>  This is a patch to fix a number of whitespace issues in the hfa384x_usb.c
>  file found by the checkpatch.pl tool
> 
> Signed-off-by: Adam Latham <adam.latham@unisontorbay.org.uk>
> ---
>  drivers/staging/wlan-ng/hfa384x_usb.c |    6 +++---

Odd, this patch doesn't apply at all to my tree.  Did you do it against
Linus's tree, or the linux-next tree?  Please do it against linux-next
as that picks up the other patches in the staging tree (500+ at the
moment.)

thanks,

greg k-h
