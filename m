Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2CWCPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:15:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64539 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2CWCPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:15:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAMfrEMbUsdnQ3Roe89YaV5F2xhTwbgRhWcM9E1jizqUEbCi=QQ@mail.gmail.com>
References: <CAMfrEMaV03CEZ-h7k9K78c8+T+AC47=QypnyhQG7LFgrQQ32tA@mail.gmail.com>
	<4F6AAC57.3090507@gmail.com>
	<CAMfrEMbUsdnQ3Roe89YaV5F2xhTwbgRhWcM9E1jizqUEbCi=QQ@mail.gmail.com>
Date: Thu, 22 Mar 2012 20:15:49 -0600
Message-ID: <CADLC3L29fiago4Nkxbb3Ey8iS3GGp_G_NP77esdAqQVYHFLBLw@mail.gmail.com>
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop 3.3.0-030300-generic
From: Robert Hancock <hancockrwd@gmail.com>
To: Chris Holland <bandidoirlandes@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 11:44 PM, Chris Holland
<bandidoirlandes@gmail.com> wrote:
>
> On Wed, Mar 21, 2012 at 11:36 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> > On 03/21/2012 10:29 PM, Chris Holland wrote:
> >>
> >> Please cc me at: bandidoirlandes@gmail.com
> >>
> >> My optical drives are not working with 3.3 but they worked fine with
> >> 3.3rc7
> >> These are the kernels from http://kernel.ubuntu.com/~kernel-ppa/mainline/
> >> Ubuntu 11.10
> >>
> >> Not working
> >> Linux desktop 3.3.0-030300-generic #201203182135 SMP Mon Mar 19
> >> 01:36:20 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> >> cat /var/log/dmesg | egrep '(CD|DVD)'
> >> [    0.000000]   CD000-EFFFF uncachable
> >>
> >> Working
> >> Linux desktop 3.3.0-030300rc7-generic #201203101735 SMP Sat Mar 10
> >> 22:36:28 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> >> cat /var/log/dmesg | egrep '(CD|DVD)'
> >> [    0.000000]   CD000-EFFFF uncachable
> >> [    0.092676] ACPI Warning: Incorrect checksum in table [TAMG] -
> >> 0xCD, should be 0xCC (20120111/tbutils-321)
> >> [    6.324511] ata9.01: ATAPI: LITE-ON DVDRW SHW-160P6S, PS0A, max UDMA/66
> >> [    6.397218] scsi 8:0:0:0: CD-ROM            LITE-ON  LTR-48246S
> >>   SS0B PQ: 0 ANSI: 5
> >> [    6.419770] cdrom: Uniform CD-ROM driver Revision: 3.20
> >> [    6.419898] sr 8:0:0:0: Attached scsi CD-ROM sr0
> >> [    6.427088] scsi 8:0:1:0: CD-ROM            LITE-ON  DVDRW
> >> SHW-160P6S PS0A PQ: 0 ANSI: 5
> >> [    6.429600] sr 8:0:1:0: Attached scsi CD-ROM sr1
> >>
> >> I tried to do a git bisect but I dont know what I am doing. Might just
> >> be my computer acting up.
> >
> >
> > Can you post the full dmesg output from the non-working kernel?

> [    3.231464] pata_jmicron 0000:03:00.1: setting latency timer to 64
> [    3.255549] scsi8 : pata_jmicron
> [    3.260534] scsi9 : pata_jmicron
> [    3.260933] ata9: PATA max UDMA/100 cmd 0xef00 ctl 0xee00 bmdma 0xeb00 irq 16
> [    3.260936] ata10: PATA max UDMA/100 cmd 0xed00 ctl 0xec00 bmdma
> 0xeb08 irq 16

Hmm, seems like nothing detected on that port at all. Do you have some
output from a working boot?
