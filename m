Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0KWMIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:08:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60232 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0KWMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:08:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LNH7ys7b3XZr7slzHLTGwDqrsKUY8aOrRVWOcwWbZvRCWQjA7wvNIo+adxbzYlcxQv
         LvlIqbpsoajIWk0fL+ag8lWitt29Ck3bBGg+brcEu8k5tnuWLUnOyOj6lS1KvXcKqOYF
         LvooyTBIi5LQJnNP79lMynfxRz9Rkhcz/b35w=
Subject: Re: sata_sil24: external raid storage mistaken as port multiplier
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1290461073.12443.21.camel@Tobias-Karnat>
References: <1290461073.12443.21.camel@Tobias-Karnat>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 13:08:45 +0100
Message-ID: <1290514125.28293.2.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 22.11.2010, 22:24 +0100 schrieb Tobias Karnat:
> My RaidSonic Stardom SR3620-2S-SB2 is mistaken as a port multiplier,
> it did work with Linux 2.6.23.

This is what I get with Linux 2.6.23:

[  242.139418] ata1: exception Emask 0x10 SAct 0x0 SErr 0x10000 action 0x2 frozen
[  242.139424] ata1: irq_stat 0x00a00080, device exchanged
[  242.859815] ata1: soft resetting port
[  243.694381] ata1: softreset failed (SRST command error)
[  243.694389] ata1: reset failed (errno=-5), retrying in 10 secs
[  252.842608] ata1: hard resetting port
[  254.982393] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  254.982489] ata1.00: ATA-6: External Disk 0, RGL10403, max UDMA/133
[  254.982492] ata1.00: 1953546336 sectors, multi 1: LBA48 
[  254.982605] ata1.00: configured for UDMA/100
[  254.982612] ata1: EH complete
[  254.982740] scsi 0:0:0:0: Direct-Access     ATA      External Disk 0  RGL1 PQ: 0 ANSI: 5
[  254.982836] sd 0:0:0:0: [sdh] 1953546336 512-byte hardware sectors (1000216 MB)
[  254.982848] sd 0:0:0:0: [sdh] Write Protect is off
[  254.982853] sd 0:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[  254.982870] sd 0:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  254.982971] sd 0:0:0:0: [sdh] 1953546336 512-byte hardware sectors (1000216 MB)
[  254.983025] sd 0:0:0:0: [sdh] Write Protect is off
[  254.983030] sd 0:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[  254.983063] sd 0:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  254.983068]  sdh: unknown partition table
[  254.988917] sd 0:0:0:0: [sdh] Attached SCSI disk
[  254.989036] sd 0:0:0:0: Attached scsi generic sg9 type 0

----------------------------
Device Type                        0
Vendor:                    ATA     
Product:                   External Disk 0 
Revision level:            RGL1

Serial Number '070C05F_879391___0_8'

-Tobias

