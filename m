Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2DBPFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:05:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63145 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2DBPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:05:05 -0400
MIME-Version: 1.0
Date: Mon, 2 Apr 2012 17:05:04 +0200
Message-ID: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
Subject: [v3.4-rc1] ACPI regression bisected
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my Notebook ( Thinkpad T43) doesn't boot with V3.4-rc1.
The kernel stops booting after displaying the following:

 ACPI: Core revision 20120320
 ACPI: setting ELCR to 0200 (from 0800)
 Performance Events: p6 PMU driver.
 ... version:                0
 ... bit width:              32
 ... generic registers:      2
 ... value mask:             00000000ffffffff
 ... max period:             000000007fffffff
 ... fixed-purpose events:   0
 ... event mask:             0000000000000003
 devtmpfs: initialized
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
 PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
 PCI: Using MMCONFIG for extended config space
 PCI: Using configuration type 1 for base access
 bio: create slab <bio-0> at 0
 ACPI: Added _OSI(Module Device)
 ACPI: Added _OSI(Processor Device)
 ACPI: Added _OSI(3.0 _SCP Extensions)
 ACPI: Added _OSI(Processor Aggregator Device)
 ACPI: EC: EC description table is found, configuring boot EC

Comparing this with the displays of kernel v3.3 the next expected
outputs would be:

 ACPI: Interpreter enabled
 ACPI: (supports S0 S5)


I bisected the problem to commit:
6fe0d0628245fdcd6fad8b837c81e8f7ebc3364d  "ACPI: Make ACPI interrupt threaded"

Please cc me I'm not subscribed.

Regards,
Joerg Otte
