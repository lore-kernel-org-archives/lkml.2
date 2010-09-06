Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0IFTfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 15:35:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0IFTfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 15:35:04 -0400
Date: Mon, 6 Sep 2010 15:35:02 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: jgarzik@redhat.com
Cc: linux-ata@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: libata acpi issue on gateway laptop
Message-ID: <20100906193501.GM2684@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

A user is reporting an issue with 2.6.34.6 on a Gateway laptop that
booting with libata.noacpi=1 resolves.

Symptom is that their device dumps a lot of messages like this:

ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ATA-8: Hitachi HTS545050B9A300, PB4OC60F, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) rejected by device
(Stat=0x51 Err=0x04)
ata1.00: configured for UDMA/133

on boot and resume from suspend.

Dmesg is at https://bugzilla.redhat.com/attachment.cgi?id=442529 and the
full bug report at https://bugzilla.redhat.com/show_bug.cgi?id=629315.

Any ideas? They say the issue exists all the way back to 2.6.31, so it
seems like a pretty long-lived bug.

Thanks!
 Kyle
