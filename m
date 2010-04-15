Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0DOLNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:13:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40389 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040Ab0DOLNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:13:11 -0400
Date: Thu, 15 Apr 2010 12:17:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: isl29020: ALS driver as misc device
Message-ID: <20100415121726.1b2a5a87@lxorguk.ukuu.org.uk>
In-Reply-To: <4BC6E5CF.9070302@jic23.retrosnub.co.uk>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414125136.23181.16788.stgit@localhost.localdomain>
	<4BC5C7A8.1040807@cam.ac.uk>
	<20100414153234.22765666@lxorguk.ukuu.org.uk>
	<4BC5D681.20707@jic23.retrosnub.co.uk>
	<20100414175602.44580f3c@lxorguk.ukuu.org.uk>
	<20100414170153.GA7494@kroah.com>
	<4BC6E5CF.9070302@jic23.retrosnub.co.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> lux-> illuminance0_input  (or I guess lux0_input would also work, I can change
> the iio abi to match this as well).
> 
> It also occurs to me that we might want to associate the calibration with the
> particular channel? There's sure to be a dual ALS chip along at some point.
> 
> Obviously the isl29020 would need updating as well.  Everyone was happy to do
> that when were writing the ALS subsystem, so I guess that won't have changed!

I'm happy to make the 29020 comply, and I guess it wouldn't take long for
someone to run over the others. Just let me know what the sysfs interface
should look like.
