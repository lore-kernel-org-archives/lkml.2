Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1JLNDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:03:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45958 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1JLNDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:03:42 -0400
Message-ID: <4E95902B.7080204@monstr.eu>
Date: Wed, 12 Oct 2011 15:03:39 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Using serial driver 16550A in poll mode without interrupt connected
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we have internal discussion around serial drivers and their usage without interrupts
in polling mode. It is on FPGA with Microblaze/PPC/ARM and
it is easy for us to have serial IP without IRQ connected to the interrupt controller.

Driver is probed with no IRQ (NO_IRQ = -1 on Microblaze)
83e00000.serial: ttyS0 at MMIO 0x83e01003 (irq = -1) is a 16550A

writing any data to ttyS0 return -1.
Is there any reason no to use driver in poll mode especially for user applications
not for consoles.

Is it possible to use serial driver without IRQ - or blocking IRQ, etc.?

Currently we care about uart16550 and uarlite.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
