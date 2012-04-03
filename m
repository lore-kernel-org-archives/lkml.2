Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2DCJna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:43:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54188 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2DCJn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:43:29 -0400
Date: Tue, 3 Apr 2012 11:43:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: linux-input@vger.kernel.org
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: psmouse serio4: bad data from KBC - timeout
Message-ID: <20120403094324.GA3346@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I'm running 3.4-rc1 on a thinkpad x121e and it builds and boots just
fine. However, after resuming from disk I get (this is the tail of
dmesg):

[  905.857412] i8042: failed to resume active multiplexor, mouse won't work
[  905.965568] usb 3-2: reset low-speed USB device number 2 using ohci_hcd
[  907.626998] psmouse serio4: bad data from KBC - timeout
[  907.675385] PM: restore of devices complete after 2358.155 msecs
[  908.227481] Restarting tasks ... done.
[  908.266229] video LNXVIDEO:01: Restoring backlight state
[  917.628792] psmouse serio4: Failed to deactivate mouse on isa0060/serio4
[  917.880639] psmouse serio4: Failed to enable mouse on isa0060/serio4
[  919.867982] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input19
[  947.277011] atl1c 0000:02:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
[  996.231116] Bluetooth: Core ver 2.16
[  996.231262] NET: Registered protocol family 31
[  996.231273] Bluetooth: HCI device and connection manager initialized
[  996.231559] Bluetooth: HCI socket layer initialized
[  996.231575] Bluetooth: L2CAP socket layer initialized
[  996.231630] Bluetooth: SCO socket layer initialized

and after that the keyboard and the mouse touchpad don't work. The
connected USB mouse works fine though.

Any help is appreciated,
thanks.

-- 
Regards/Gruss,
Boris.
