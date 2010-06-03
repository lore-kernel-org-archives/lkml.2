Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0FCH2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:28:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35493 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0FCH2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R1CKn92P5cozymqs82Fn5z400QZtZ9FuzNQvmgyqi424lhlCdOS4PB64EXd9N9g5AD
         GqH5DPCxOsaza/9FI/4DUdjqmrjhsD+vPEm0qTJOzzQip4ju9n/m+Ear1YvLfbohOvKe
         bLr41JsQysIt/kkEUItEd1BPu5Q7jHPyjwWiQ=
MIME-Version: 1.0
In-Reply-To: <4C07561F.5080202@garzik.org>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
	<4C07561F.5080202@garzik.org>
Date: Thu, 3 Jun 2010 15:28:50 +0800
Message-ID: <AANLkTim5UblANgkOj2XNjNw-h2JMKsXRkuMpROpEOlpZ@mail.gmail.com>
Subject: Re: 2.6.25-rc1 ahci regression
From: Luming Yu <luming.yu@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, avorontsov@ru.mvista.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 3:13 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 06/03/2010 03:02 AM, Luming Yu wrote:
>>
>> Hi there,
>>
>> I happened to notice that the commit 365cfa1ed5 caused the following
>> boot error with 2.6.25-rc1
>> on a system with ICH10 SATA AHCI controller. It's weird if there is
>> really no function changes in the patch.
>>
>> Any ideas?
>>
>>
>> dracut: Starting plymouth daemon
>> pata_jmicron 0000:0f:00.0: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
>> scsi0 : pata_jmicron
>> Initializing USB Mass Storage driver...
>> scsi1 : usb-storage 1-5:1.0
>> scsi2 : pata_jmicron
>> ata1: PATA max UDMA/100 cmd 0xd040 ctl 0xd030 bmdma 0xd000 irq 16
>> ata2: PATA max UDMA/100 cmd 0xd020 ctl 0xd010 bmdma 0xd008 irq 16
>> usbcore: registered new interface driver usb-storage
>> USB Mass Storage support registered.
>> scsi 1:0:0:0: CD-ROM            PepperC  Virtual Disc 1   0.01 PQ: 0 ANSI:
>> 3
>> sr0: scsi-1 drive
>
> Your output here does not indicate a boot error, so to what do you refer?
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.20

Boot has failed, sleeping forever.




>
