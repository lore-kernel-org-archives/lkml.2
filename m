Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2LCLQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:16:53 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45873 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab2LCLQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:16:48 -0500
Message-ID: <50BC8A1C.8070805@suse.cz>
Date: Mon, 03 Dec 2012 12:16:44 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: ata1: COMRESET failed
References: <508A7A8A.7030908@suse.cz>
In-Reply-To: <508A7A8A.7030908@suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 01:56 PM, Jiri Slaby wrote:
> Hello,
> 
> at every boot I'm seeing:
> 
> At 5th second:
> ata1: link is slow to respond, please be patient (ready=0)
> 
> At 10th second:
> ata1: COMRESET failed (errno=-16)
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> ata1.00: ATA-7: INTEL SSDSA2M080G2GC, 2CV102HD, max UDMA/133
> ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> ata1.00: configured for UDMA/133
> scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
> 
> 
> So that I have to wait 5 s for the disk to come up. I tried 3.4.15 and
> 3.6.3, both with the same result.
> 
> 00:1f.2 SATA controller [0106]: Intel Corporation 7 Series Chipset
> Family 6-port SATA Controller [AHCI mode] [8086:1e03] (rev 04)
> 
> Any ideas what is going on?

Anybody? I also tried 3.0, it's there too. And libahci.skip_host_reset=1
works around the issue.

> thanks,
-- 
js
suse labs
