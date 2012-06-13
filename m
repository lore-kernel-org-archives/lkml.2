Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2FMA6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 20:58:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2FMA6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 20:58:39 -0400
Date: Tue, 12 Jun 2012 17:58:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, oneukum@suse.de, alan@lxorguk.ukuu.org.uk,
        thomas.braunstorfinger@rohde-schwarz.com
Subject: Re: [PATCH] add new NRP power meter USB device driver
Message-ID: <20120613005835.GA6665@kroah.com>
References: <1338713172-7496-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338713172-7496-1-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 10:46:12AM +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This driver supports all of the Rohde&Schwarz RF Power Meter NRP Sensors. These
> sensors are intelligent standalone instruments that communicate via USB.
> 
> A power meter is a device for analyzing the RF power output level of an
> electrical device, similar to an oscilloscope.
> 
> The Power Meter Sensors will be used in a wide range of environements, like
> 
> - Manufacturing (e.g. air planes and smart phones)
> - Radio and TV broadcasting
> - Mobile communications
> - Engeeniering
> - Science Labs
> - Education
> 
> The NRP Power Meters support the following measurements:
> 
>  - Dynamic range: up to 90 dB (sensor dependent)
>  - Level range: -67 dBm to +45 dBm (sensor dependent)
>  - Frequency range: DC to 67 GHz (sensor dependent)
>  - Measurement speed: 1500 measurements per second in the buffered mode
>  - Linearity uncertainty: 0.007 dB
>  - Precise average power measurements irrespective of modulation and bandwidth
>  - Flexible measurements on up to 128 time slots per power sensor
>  - S parameter correction of components between sensor and test object
> 
> The device will be controlled by a SCPI like interface.
> (https://en.wikipedia.org/wiki/Standard_Commands_for_Programmable_Instruments)

I still don't see any performance numbers stating why this needs to be a
kernel driver...

Also, what happened to the IIO interface for this instead of a custom
syscall/ioctl for just this device type?

thanks,

greg k-h
