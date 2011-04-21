Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1DURe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:34:56 -0400
Received: from lucidpixels.com ([75.144.35.66]:52885 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab1DURez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:34:55 -0400
Date: Thu, 21 Apr 2011 13:34:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nut-upsuser@lists.alioth.debian.org
Subject: 2.6.38.3 w/nut: libusb_get_string: error sending control message:
 Broken pipe
Message-ID: <alpine.DEB.2.02.1104211247370.4005@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Dist: Debian Testing
Kernel: 2.6.38.3
Software: nut 2.6.0-1

I believe this is a chipset bug, are there any plans for a workaround?
The messages have changed over the kernel versions for this problem, but
the problem itself still exists:

Apr 21 09:17:25 p34 usbhid-ups[3737]: libusb_get_string: error sending control
message: Broken pipe
Apr 21 09:44:20 p34 usbhid-ups[3737]: libusb_get_string: error sending control
message: Broken pipe

Error from 2009 (still a problem)
http://lists.alioth.debian.org/pipermail/nut-upsuser/2009-October/005530.html

This occurred on my last Intel motherboard (Intel 965WH) and current
motherboard, Intel DP55KG.

Is there something that can be 'fixed' or an workaround implemented, or
should I just send these messages to /dev/null?

As the nut software does work OK, I keep getting these errors in the logs.

Thanks,

Justin.




