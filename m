Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2IUUgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:36:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40057 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab2IUUge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:36:34 -0400
MIME-Version: 1.0
X-Originating-IP: [2a02:2f01:1028:2046:227:10ff:fe84:1b54]
In-Reply-To: <CAEG-z28YsUnF6dvHf3+FPbPNnVihV78VmeUDDJku9X1DEs0GxQ@mail.gmail.com>
References: <CAEG-z28YsUnF6dvHf3+FPbPNnVihV78VmeUDDJku9X1DEs0GxQ@mail.gmail.com>
From: Adrian Sandu <dexter@d3xt3r01.tk>
Date: Fri, 21 Sep 2012 23:36:13 +0300
Message-ID: <CAEG-z2_BR8cTJBcPENqHxBHVTf6OF8nzM3TNvWvZ3pj1FQ78kw@mail.gmail.com>
Subject: usb3 hub disconnection
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi peeps,

I've just got a manhattan usb3 hub. It has its own power source.

kernel: [13609.728988] usb 3-1: new high-speed USB device number 22
using xhci_hcd
kernel: [13609.728999] xhci_hcd 0000:05:00.0: ERROR: unexpected
command completion code 0x0.
kernel: [13609.942803] usb 3-1: New USB device found, idVendor=2109,
idProduct=3431
kernel: [13609.942809] usb 3-1: New USB device strings: Mfr=0,
Product=1, SerialNumber=0
kernel: [13609.942812] usb 3-1: Product: USB2.0 Hub
kernel: [13609.943593] hub 3-1:1.0: USB hub found
kernel: [13609.944002] hub 3-1:1.0: 4 ports detected
kernel: [13610.053091] xhci_hcd 0000:05:00.0: ERROR: unexpected
command completion code 0x0.
kernel: [13610.253630] usb 4-1: new SuperSpeed USB device number 109
using xhci_hcd
kernel: [13610.601719] usb 4-1: Parent hub missing LPM exit latency
info.  Power management will be impacted.
kernel: [13610.745666] usb 4-1: New USB device found, idVendor=2109,
idProduct=0810
kernel: [13610.745671] usb 4-1: New USB device strings: Mfr=1,
Product=2, SerialNumber=0
kernel: [13610.745675] usb 4-1: Product: 4-Port USB 3.0 Hub
kernel: [13610.745678] usb 4-1: Manufacturer: VIA Labs, Inc.
kernel: [13610.749209] hub 4-1:1.0: USB hub found
kernel: [13610.801433] hub 4-1:1.0: 4 ports detected

Now, in this hub I plug 4 usb3 drives ( each have their own power
source ). And I connect it to an usb3 port in my computer.
I can mount them, browse them. Great 'till I start to actually move
data between them or write something on them.

kernel: [ 1473.153550] usb 4-2.4: reset SuperSpeed USB device number 5
using xhci_hcd
kernel: [ 1473.166449] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint
called with disabled ep ffff88011cf6b280
kernel: [ 1473.166461] xhci_hcd 0000:04:00.0: xHCI xhci_drop_endpoint
called with disabled ep ffff88011cf6b2c0

Works just fine if plugged in an usb2 port.

Same drives, same hub but plugged in my laptop work just great.
My laptop is a vaio vpcf13m1e ( which seems to work ). The one with
problems is an asrock 152d.

Any way to help ya' guys debug/solve the issue ?

Thanks in advance,
  Adrian.
