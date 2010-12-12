Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0LMAcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:32:06 -0500
Received: from smtp-rs1-vallila2.fe.helsinki.fi ([128.214.173.75]:51034 "EHLO
	smtp-rs1.it.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab0LMAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:32:03 -0500
X-Greylist: delayed 3612 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 19:32:03 EST
Date: Mon, 13 Dec 2010 01:31:44 +0200 (EET)
From: Jouko Orava <jouko.orava@helsinki.fi>
Reply-To: Jouko Orava <jouko.orava@helsinki.fi>
To: linux-kernel@vger.kernel.org
Subject: Custom kernel logging using an USB microcontroller?
Message-ID: <alpine.LRH.2.00.1012130108200.12183@ruuvi.it.helsinki.fi>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Would any of you happen to have written a kernel module for
custom kernel logging to a USB microcontroller?

I'm having unexpected shutdowns/reboots with absolutely no
sign of the cause in any logs, when using the radeon driver
heavily, and having kernel MCE support enabled. Disabling kernel
MCE support seems to eliminate the problem. See
https://bugs.freedesktop.org/show_bug.cgi?id=30349 for details.

I don't have suitable hardware for a serial console, so
this is proving really difficult to investigate.

I do, however, have a USB AVR microcontroller (pjrc.com/teensy),
which has a few thousand bytes of RAM; I'd like to use it as a custom
logging device. Specifically, I need an in-kernel interface to log
directly to the USB microcontroller, so I can find out the codepath
causing the problems I'm having. (I suspect thermal or voltage
misreporting, so a printk interface would be useful.)
I don't really want nor need to save the entire kernel log.

Since these USB microcontrollers are dirt cheap (24 USD), need only
an USB cable to work, and are very easy to program as HID devices using
avr-gcc, it occurs to me that this has probably been already done.
It seems like a useful tool for any kernel or kernel module developer.

So, any pointers to existing code I could adapt?
Or hints on how the kernel-side logging via USB should be done?

Thanks for your time,
	Jouko Orava
