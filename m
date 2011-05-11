Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab1EKTdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:33:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43139 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1EKTdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=bIJHcsD8u8AV7SgpQr7KtxyymrfMUH/erDZw/YjcZyChzv+1KRxdcmF/AxEcVzMGRj
         o+PBCLePxVmKktuR7L8SUHNKy5JMA4jM3iBieRRPLMALYexl73xyH+HgBBMSKUK7WsDa
         WldhueCSbHn+4U9L5yvQ1f06DpkhkgPny50PM=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: 2.6.39-rc6: SATA hangs for a few seconds during boot
Date: Wed, 11 May 2011 21:33:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc6; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20110509204801.GA2258@x61.home>
In-Reply-To: <20110509204801.GA2258@x61.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105112133.09261.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=34952
for your bug report, please add your address to the CC list in there, thanks!

On poniedziałek, 9 maja 2011 o 22:48:01 Tino Keitel wrote:
> Hi,
> 
> I get a hanging SATA port for a few seconds during boot, with these
> kernel messages:
> 
> ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x40000 action 0x6 frozen
> ata1.00: cmd 60/20:00:55:e1:65/00:00:00:00:00/40 tag 0 ncq 16384 in
>          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1.00: cmd 60/02:08:c1:5c:03/00:00:00:00:00/40 tag 1 ncq 1024 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: hard resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: both IDENTIFYs aborted, assuming NODEV
> ata1.00: revalidation failed (errno=-2)
> ata1: hard resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (unknown) succeeded
> ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (unknown) filtered out
> ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (unknown) succeeded
> ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (unknown) filtered out
> ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (unknown) succeeded
> ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (unknown) filtered out
> ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (unknown) succeeded
> ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (unknown) filtered out
> ata1.00: configured for UDMA/133
> ata1.00: device reported invalid CHS sector 0
> ata1.00: device reported invalid CHS sector 0
> ata1: EH complete
> 
> This happens with 2.6.39-rc6 with TuxOnIce patch included, but during boot
> without any suspend actions. The hardware is a ThinkPad X61s:
> 
> 00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
> SATA AHCI Controller (rev 03)
> 
> Complete dmesg is attached.
> 
> Regards,
> Tino

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
