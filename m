Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab1EBIbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:31:21 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:44257 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920Ab1EBIbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:31:20 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-05.arcor-online.net 947F1E4055
Date: Mon, 2 May 2011 10:31:17 +0200
From: Klaus Dittrich <kladit@arcor.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.38.5-rc1 usb problem
Message-ID: <20110502083117.GA1968@df1tl.local.here>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.38.5-rc1 my usb-scanner will be not detected, with 2.6.38.4 it
will.

System is Intel Q9550 SMP 64-bit

/var/log/messages ..

May  2 10:07:12 x1 klogd: [ 3030.380011] usb 3-1: new full speed USB device using uhci_hcd and address 16
May  2 10:07:27 x1 klogd: [ 3045.500013] usb 3-1: device descriptor read/64, error -110
May  2 10:07:42 x1 klogd: [ 3060.730008] usb 3-1: device descriptor read/64, error -110
May  2 10:07:42 x1 klogd: [ 3060.960012] usb 3-1: new full speed USB device using uhci_hcd and address 17
May  2 10:07:57 x1 klogd: [ 3076.080010] usb 3-1: device descriptor read/64, error -110
May  2 10:08:13 x1 klogd: [ 3091.310011] usb 3-1: device descriptor read/64, error -110
May  2 10:08:13 x1 klogd: [ 3091.540009] usb 3-1: new full speed USB device using uhci_hcd and address 18
May  2 10:08:23 x1 klogd: [ 3101.960009] usb 3-1: device not accepting address 18, error -110
May  2 10:08:23 x1 klogd: [ 3102.080009] usb 3-1: new full speed USB device using uhci_hcd and address 19
May  2 10:08:34 x1 klogd: [ 3112.500010] usb 3-1: device not accepting address 19, error -110
May  2 10:08:34 x1 klogd: [ 3112.500024] hub 3-0:1.0: unable to enumerate USB device on port 1


/var/log/messages of 2.6.38.4

May  2 10:17:56 x1 klogd: [   61.308007] usb 7-2: new full speed USB device using uhci_hcd and address 2
May  2 10:17:57 x1 klogd: [   61.472210] usb 7-2: New USB device found, idVendor=10c4, idProduct=ea60
May  2 10:17:57 x1 klogd: [   61.472213] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
May  2 10:17:57 x1 klogd: [   61.472215] usb 7-2: Product: CP2102 USB to UART Bridge Controller
May  2 10:17:57 x1 klogd: [   61.472217] usb 7-2: Manufacturer: Silicon Labs May  2 10:17:57 x1 klogd: [   61.472219] usb 7-2: SerialNumber: 0001
May  2 10:18:08 x1 klogd: [   73.328009] usb 3-1: new full speed USB device using uhci_hcd and address 4
May  2 10:18:09 x1 klogd: [   73.842237] usb 3-1: New USB device found, idVendor=04b8, idProduct=010a
May  2 10:18:09 x1 klogd: [   73.842239] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May  2 10:18:09 x1 klogd: [   73.842242] usb 3-1: Product: Perfection1640 May  2 10:18:09 x1 klogd: [   73.842243] usb 3-1: Manufacturer: EPSON


Please cc me, I am not subscribed.

-- 
Klaus
