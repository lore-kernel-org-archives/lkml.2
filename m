Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab1C3Tck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:32:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64230 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1C3Tcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:32:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=rwcFoLFBfDJ3EVsrnNc3Zfo6+IjmQ9o3CXggSime/bHGb61EsXXrv8bpyMqQxzA7zJ
         sZjlbxx+1dgIURcqTQ83/q85agzBsa/0lLZjnjPkF/z93VjyisRP1WdKkFu3Z2uU63WC
         G8xVq/00Tiwf/Mm4ySHvQyBCTr7G4dEHnKuFE=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Pete Clements <clem@clem.clem-digital.net>
Subject: Re: 2.6.38-git15+  IDE hangs boot
Date: Wed, 30 Mar 2011 21:32:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201103251538.p2PFc11i001674@clem.clem-digital.net>
In-Reply-To: <201103251538.p2PFc11i001674@clem.clem-digital.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103302132.32899.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=32262
for your bug report, please add your address to the CC list in there, thanks!

On piątek, 25 marca 2011 o 16:38:01 Pete Clements wrote:
> Fyi:
> 2.6.38-git15+ bootup hangs with IDE. Following copied from screen:
> 
> Uniform Multi-Platform E-IDE driver
> piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
> piix 0000:00:07.1: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0x10a0-0x10a7
>     ide1: BM-DMA at 0x10a8-0x10af
> hda: Maxtor 90913D4, ATA DISK drive
> hdb: ST51080A, ATA DISK drive
> hda: UDMA/33 mode selected
> hdb: MWDMA2 mode selected
> Switching to clock source tsc
> hdc: CRD-8400B, ATAPI CD/DVD-ROM drive
> hdc: Disabling (U)DMA for CRD-8400B (blacklisted)
> ide0 at 0x1f0-0x1f7,0x3f6 0n irq 14
> ide1 at 0x170-0x177,0x376 on irq 15
> ide_generic: please use "probe_mask=0x3f" module parameter for probing all
> legacy ISA IDE ports ide-gd driver 1.18
> hda: max request size: 128KiB

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
