Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2ENUxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:53:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2ENUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:53:38 -0400
Date: Mon, 14 May 2012 13:53:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: Staging: comedi: Clean up patch series.
Message-ID: <20120514205333.GA26338@kroah.com>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:07:48PM +0530, Ravishankar Karkala Mallikarjunayya wrote:
> This patch series fixes some style issues in drivers/staging/comedi/drivers
> and fix some issues found by checkpatch.pl script.
> 
> Ravishankar Karkala Mallikarjunayya (25):
>       Staging: comedi: fix printk issue in usbduxfast.c
>       Staging: comedi: fix printk issues in usbduxfast.c
>       Staging: comedi: fix printk issue in usbduxfast.c
>       Staging: comedi: fix printk issue in usbduxfast.c
>       Staging: comedi: fix printk issue in usbduxfast.c
>       Staging: comedi: fix printk issue in usbduxfast.c
>       Staging: comedi: fix printk issues in usbduxfast.c
>       Staging: comedi: fix printk issue in rti800.c
>       Staging: comedi: fix printk issue in rti802.c
>       Staging: comedi: fix printk issue in s526.c
>       Staging: comedi: fix printk issue in s626.c
>       Staging: comedi: Checkpatch cleanups.
>       Staging: comedi: Checkpatch cleanups.
>       Staging: comedi: fix printk issue in serial2002.c
>       Staging: comedi: fix printk issue in unioxx5.c
>       Staging: comedi: fix printk issues in unioxx5.c
>       Staging: comedi: fix line over 80 character issue in unioxx5.c
>       Staging: comedi: Checkpatch cleanups.
>       Staging: comedi: Checkpatch cleanups.
>       Staging: comedi: Checkpatch cleanups.
>       Staging: comedi: fix printk issue in pcmmio.c.
>       Staging: comedi: fix printk issue in pcmad.c
>       Staging: comedi: fix printk issue in poc.c
>       Staging: comedi: fix printk issue in ni_pcimio.c
>       Staging: comedi: fix printk issue in ni_660x.c

You have lots of duplicated Subject: lines in here, that are not
descriptive at all.  You also do much the same exact thing in the same
exact files, yet you split it up into different patches for no apparent
reason at all.

Please rework this series to make one "logic" change per file, and make
better subject: lines that are understandable, I can't take any of these
as-is, sorry.

greg k-h
