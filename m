Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab2AFAMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:12:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39450 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AFAMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:12:47 -0500
MIME-Version: 1.0
In-Reply-To: <m11urffgja.fsf@fess.ebiederm.org>
References: <CAHa016cp4uNZqCvJW0RZgEXST-VqpVWjYSXGE+RhThXXo6nzCA@mail.gmail.com>
 <m11urffgja.fsf@fess.ebiederm.org>
From: =?UTF-8?B?TnVtYW4gREVNxLBSRMOWxJ5FTg==?= <numand46@gmail.com>
Date: Fri, 6 Jan 2012 02:12:25 +0200
Message-ID: <CAHa016cty=BUZ_ofksbRawLUfhyzYxwYtW+-iPR24vq_gEFCcA@mail.gmail.com>
Subject: Re: sdhci causing WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x9b/0xd0()
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/4 Eric W. Biederman <ebiederm@xmission.com>:
> Hopefully I have added some relevant Cc's.  The sdhci driver attempting
> to abuse sysfs and sysfs is refusing to put up with it.
>
> Can someone who understands the sdhci driver take a look at this?
>
> Eric

I forgot to add lspci output. Sorry for this. I added the relevant
device that is being pointed in warning.

lspci:
06:09.4 SD Host controller [0805]: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
[104c:8034]
	Subsystem: Wistron Corp. Device [17c0:3007]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 57 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at b8009400 (32-bit, non-prefetchable) [size=256]
	Region 1: Memory at b8009000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at b8007400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci
