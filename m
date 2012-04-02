Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab2DBJOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:14:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42466 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2DBJOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:14:45 -0400
MIME-Version: 1.0
Date: Mon, 2 Apr 2012 09:14:44 +0000
Message-ID: <CAH9_E90HZcV2XPDUtbat42KQjeJOp8yGW3aUG9PiJJzQT3+swg@mail.gmail.com>
Subject: PROBLEM: Kconfig documenation typos
From: Alexi Somebody <alexi.nones@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a couple of typographical errors on lines 414 and 424 of,

Kernel Version: Linux 3.4.0-rc1

[linux/kernel/git/torvalds/linux.git] / drivers / usb / host / Kconfig

 408 config USB_OHCI_HCD_PLATFORM
 409         bool "Generic OHCI driver for a platform device"
 410         depends on USB_OHCI_HCD && EXPERIMENTAL
 411         default n
 412         ---help---
 413           Adds an OHCI host driver for a generic platform device, which
 414           provieds a memory space and an irq.
 415
 416           If unsure, say N.
 417
 418 config USB_EHCI_HCD_PLATFORM
 419         bool "Generic EHCI driver for a platform device"
 420         depends on USB_EHCI_HCD && EXPERIMENTAL
 421         default n
 422         ---help---
 423           Adds an EHCI host driver for a generic platform device, which
 424           provieds a memory space and an irq.


It should be "provides" rather than "provieds" on line 414 and 424.


Regards, Alexi.
