Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0EaWNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:13:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54410 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0EaWNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FonRgn372FgZHiffi9D/8mbiT9i5zeYpGvC28+B4JJs9LyEMK3ZQH+Q/HHVrhXYxGD
         i0fFbkTJME9T55eBcJegkBnVJ6DqhUL1sJTWNih2e70dHxe8sf4O5XK9D7POtuBXwWUo
         5Ii7k2L7OB8qJ+jM/ZtR9rAC2frX8nCkXnkGw=
MIME-Version: 1.0
Date: Mon, 31 May 2010 17:12:38 -0500
Message-ID: <AANLkTinmBxzM4IEgrY6gqokDhLJDrVyKd0cu75VaFR8Q@mail.gmail.com>
Subject: resource piix4_smbus conflicts with ACPI region SMRG
From: Richard Tillmore <rtillmore@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was running 2.6.30 until I had time to update.  Being a long weekend
I upgraded to 2.6.34-rc6 and noticed a few new messages in dmesg.  I
then installed 2.6.34 and the messages remain.

PCI: Ignoring host bridge windows from ACPI; if necessary, use
"pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)

ACPI: resource piix4_smbus [io  0x0440-0x0447] conflicts with ACPI
region SMRG [??? 0x00000440-0x0000044f flags 0x47]
ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver

The system is a Tyan Tiger S1832 motherboard with a P3 850Mhz
processor running the latest bios.  Everything appears to work
properly so I am unsure what the messages mean beyond the obvious.  I
did a little research and was wondering if this is related to the no
bootmem patches.  I have:
CONFIG_NO_BOOTMEM=y
in my .config

I have the full dmesgs from 2.6.30, 2.6.34-rc6 and 2.6.34 if you need
to see them.  I can also post my config if requested.

Thanks,
Rich
