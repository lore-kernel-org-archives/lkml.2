Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0IFTpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 15:45:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:50283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab0IFTpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 15:45:38 -0400
Message-ID: <4C854502.8040009@kernel.org>
Date: Mon, 06 Sep 2010 21:46:10 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: jgarzik@redhat.com, linux-ata@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: libata acpi issue on gateway laptop
References: <20100906193501.GM2684@bombadil.infradead.org>
In-Reply-To: <20100906193501.GM2684@bombadil.infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Sep 2010 19:45:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2010 09:35 PM, Kyle McMartin wrote:
> Hi Jeff,
> 
> A user is reporting an issue with 2.6.34.6 on a Gateway laptop that
> booting with libata.noacpi=1 resolves.
> 
> Symptom is that their device dumps a lot of messages like this:
> 
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device
> (Stat=0x51 Err=0x04)
> ata1.00: ACPI cmd ef/10:01:00:00:00:a0 (SET FEATURES) succeeded
> ata1.00: ACPI cmd ef/10:02:00:00:00:a0 (SET FEATURES) succeeded
> ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> ata1.00: ACPI cmd ef/10:04:00:00:00:a0 (SET FEATURES) succeeded
> ata1.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) rejected by device
> (Stat=0x51 Err=0x04)
> ata1.00: ATA-8: Hitachi HTS545050B9A300, PB4OC60F, max UDMA/133
> ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
> ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device
> (Stat=0x51 Err=0x04)
> ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> ata1.00: ACPI cmd ef/10:05:00:00:00:a0 (SET FEATURES) rejected by device
> (Stat=0x51 Err=0x04)
> ata1.00: configured for UDMA/133
> 
> on boot and resume from suspend.
> 
> Dmesg is at https://bugzilla.redhat.com/attachment.cgi?id=442529 and the
> full bug report at https://bugzilla.redhat.com/show_bug.cgi?id=629315.
> 
> Any ideas? They say the issue exists all the way back to 2.6.31, so it
> seems like a pretty long-lived bug.

These are debug/info messages.  Just ignore them.

-- 
tejun
