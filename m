Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab2AOIPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 03:15:52 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:24830 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2AOIPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 03:15:51 -0500
Date: Sun, 15 Jan 2012 09:15:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alejandro <scasbyte@gmail.com>
Cc: guenter.roeck@ericsson.com, linux-kernel@vger.kernel.org,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [RFC][PATCH 2/2] hwmon: (w83627ehf) Add GPIO port 3
 functionality
Message-ID: <20120115091535.2f0f5bb0@endymion.delvare>
In-Reply-To: <4F11FE6C.8020808@gmail.com>
References: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com>
	<20120114211856.7e1b816d@endymion.delvare>
	<4F11FE6C.8020808@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012 16:15:08 -0600, Alejandro wrote:
> On 14-Jan-12 2:18 PM, Jean Delvare wrote:
> > This is calling for a MFD driver for these chips. This was proposed in
> > the past, BTW, but never followed up:
> > http://lists.lm-sensors.org/pipermail/lm-sensors/2010-February/027795.html
> >
> > Putting everything in the current driver is not going to be accepted.
> > It certainly looks pleasant because it's a more simple approach, but
> > the result would be a complex and unmaintainable driver.
> 
> The patch looks great, and it is definitely more maintainable. I'll 
> create a patch for the w83627ehf driver and send it as soon as possible. 
> Should I make the patch for the w83627hf or wait for Rodolfo???

Despite the similar names, these drivers are independent, they don't
have to be converted at the same time. So just do what you need for
yourself.

To be honest I thought that w83627ehf was the driver Rudolfo had
attempted to convert, not w83627hf. I remembered incorrectly. But at
least it gives you an idea of how the conversion should be done. Note
that Rudolfo's work wasn't properly reviewed (otherwise it would be
upstream by now) so I can't guarantee it's 100% correct, but at least
the mfd structure should be good enough to use as an example.

-- 
Jean Delvare
