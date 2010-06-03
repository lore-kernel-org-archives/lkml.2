Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0FCHNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:13:47 -0400
Received: from mail-yw0-f179.google.com ([209.85.211.179]:36736 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0FCHNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DPADNXZUK9hltmVJQrAxHFr1wPel0CtzXFVjR2y5n0NKmRzUM9+NkcGm/N1+BBqnOi
         7w42w0+TdPDDx/KgiHe1U1zZCalbXjpYuMS+X23gVLSiDLU9L5reqIs+bGCo6jSzSXDB
         ttxtJK4Jr/txz84hGU+OFTJ51e+hMIcPtMejM=
Message-ID: <4C07561F.5080202@garzik.org>
Date: Thu, 03 Jun 2010 03:13:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, avorontsov@ru.mvista.com
Subject: Re: 2.6.25-rc1 ahci regression
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
In-Reply-To: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 03:02 AM, Luming Yu wrote:
> Hi there,
>
> I happened to notice that the commit 365cfa1ed5 caused the following
> boot error with 2.6.25-rc1
> on a system with ICH10 SATA AHCI controller. It's weird if there is
> really no function changes in the patch.
>
> Any ideas?
>
>
> dracut: Starting plymouth daemon
> pata_jmicron 0000:0f:00.0: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
> scsi0 : pata_jmicron
> Initializing USB Mass Storage driver...
> scsi1 : usb-storage 1-5:1.0
> scsi2 : pata_jmicron
> ata1: PATA max UDMA/100 cmd 0xd040 ctl 0xd030 bmdma 0xd000 irq 16
> ata2: PATA max UDMA/100 cmd 0xd020 ctl 0xd010 bmdma 0xd008 irq 16
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> scsi 1:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI: 3
> sr0: scsi-1 drive

Your output here does not indicate a boot error, so to what do you refer?

	Jeff




