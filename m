Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2LQPgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:36:15 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35224 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2LQPgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:36:11 -0500
Message-ID: <50CF3BE7.7080509@lwfinger.net>
Date: Mon, 17 Dec 2012 09:36:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Unable to enumerate USB device messages back in 3.7-gitX
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Unfortunately, those pesky messages have returned since the 3.8 merge has 
started. Using 'git describe', my system is v3.7-8805-ga4f1de1. The USB-related 
messages logged are as follows:

  usbcore: registered new interface driver usbfs
  usbcore: registered new interface driver hub
  usbcore: registered new device driver usb
  ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
  ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
  ohci_hcd 0000:00:02.0: setting latency timer to 64
  ohci_hcd 0000:00:02.0: OHCI Host Controller
  ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
  ohci_hcd 0000:00:02.0: irq 17, io mem 0xfc486000
  hub 1-0:1.0: USB hub found
  hub 1-0:1.0: 5 ports detected
  ohci_hcd 0000:00:04.0: setting latency timer to 64
  ohci_hcd 0000:00:04.0: OHCI Host Controller
  ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 2
  ohci_hcd 0000:00:04.0: irq 16, io mem 0xfc487000
  hub 2-0:1.0: USB hub found
  hub 2-0:1.0: 5 ports detected
  usb 1-4: new full-speed USB device number 2 using ohci_hcd
  usb 2-2: new full-speed USB device number 2 using ohci_hcd
  hub 2-0:1.0: unable to enumerate USB device on port 5
  hub 2-0:1.0: unable to enumerate USB device on port 5
  <plus a lot more of the above>

I have not yet had time to bisect the problem, but I will do so ASAP. I mostly 
want you to have a heads-up that the problem has returned.

Thanks,

Larry
