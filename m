Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab0FJEjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 00:39:55 -0400
Received: from clueserver.org ([65.102.45.174]:51402 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab0FJEjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 00:39:53 -0400
Message-ID: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2>
Date: Wed, 9 Jun 2010 21:39:52 -0700 (PDT)
Subject: Question on siig sata 3 controller
From: "Alan" <alan@clueserver.org>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone know the status of the SIIG DP SATA 6Gb/s 2S1P PCIe (Part
number: SC-SA0E12-S1)?

I am encountering problems writing a large quantity through this
controller and I want to see if there is a way to fix this.  The pci ids
do not appear to be referenced in the kernel.

Are any of the siig sata controllers supported? Is there some issue with
them supporting Linux that I am not aware of?

Here is the lspci data:

05:00.0 SATA controller: Device 1b4b:9123 (rev 11) (prog-if 01 [AHCI 1.0])
	Subsystem: Device 1b4b:9123
	Flags: bus master, fast devsel, latency 0, IRQ 30
	I/O ports at dc00 [size=8]
	I/O ports at d880 [size=4]
	I/O ports at d800 [size=8]
	I/O ports at d480 [size=4]
	I/O ports at d400 [size=16]
	Memory at f9fff800 (32-bit, non-prefetchable) [size=2K]
	Expansion ROM at f9fe0000 [disabled] [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

05:00.1 IDE interface: Device 1b4b:91a4 (rev 11) (prog-if 8f [Master SecP
SecO PriP PriO])
	Subsystem: Device 1b4b:91a4
	Flags: fast devsel, IRQ 18
	I/O ports at d080 [size=8]
	I/O ports at d000 [size=4]
	I/O ports at cc00 [size=8]
	I/O ports at c880 [size=4]
	I/O ports at c800 [size=16]
	Memory at f9fff400 (32-bit, non-prefetchable) [size=16]
	Expansion ROM at f9fd0000 [disabled] [size=64K]
	Capabilities: <access denied>
	Kernel modules: ata_generic, pata_acpi

Thanks!

