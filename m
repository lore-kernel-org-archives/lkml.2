Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2CNPta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:49:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45072 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2CNPt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6y4gpf28zweFgC_Up+dcHtKcf9=YJ7TjUGKRsJo8FMsw@mail.gmail.com>
References: <CAC9WiBiZ9oOaDaYjow-ZryZ8i=7uLixTAfm48YKVpbwQfLfayQ@mail.gmail.com>
	<CA+5PVA6y4gpf28zweFgC_Up+dcHtKcf9=YJ7TjUGKRsJo8FMsw@mail.gmail.com>
Date: Wed, 14 Mar 2012 16:49:28 +0100
Message-ID: <CAC9WiBhaLiMqNRa33TOj1boTmFBh5DgjN6+8AmQbBYUgy=CGNg@mail.gmail.com>
Subject: Re: Getting oops with 3.2.10 when removing a SD card
From: Francis Moreau <francis.moro@gmail.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 4:43 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Wed, Mar 14, 2012 at 11:38 AM, Francis Moreau <francis.moro@gmail.com> wrote:
>> Hi,
>>
>> I'm getting this oops (pretty often) after writing to a SD card and
>> removing the card.
>>
>> Here's the oops:
>>
>> [17610.371580] usb 1-1.6: new high-speed USB device number 14 using ehci_hcd
>> [17610.469928] usb 1-1.6: New USB device found, idVendor=0bda, idProduct=0159
>> [17610.469935] usb 1-1.6: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [17610.469939] usb 1-1.6: Product: USB2.0-CRW
>> [17610.469942] usb 1-1.6: Manufacturer: Generic
>> [17610.469946] usb 1-1.6: SerialNumber: 20071114173400000
>> [17610.485966] scsi16 : usb-storage 1-1.6:1.0
>> [17611.489253] scsi 16:0:0:0: Direct-Access     Generic- Multi-Card
>>   1.00 PQ: 0 ANSI: 0 CCS
>> [17611.489556] sd 16:0:0:0: Attached scsi generic sg2 type 0
>> [17612.177470] sd 16:0:0:0: [sdb] 7744512 512-byte logical blocks:
>> (3.96 GB/3.69 GiB)
>> [17612.178347] sd 16:0:0:0: [sdb] Write Protect is off
>> [17612.178355] sd 16:0:0:0: [sdb] Mode Sense: 03 00 00 00
>> [17612.179333] sd 16:0:0:0: [sdb] No Caching mode page present
>> [17612.179338] sd 16:0:0:0: [sdb] Assuming drive cache: write through
>> [17612.182988] sd 16:0:0:0: [sdb] No Caching mode page present
>> [17612.182993] sd 16:0:0:0: [sdb] Assuming drive cache: write through
>> [17612.214565]  sdb: sdb1
>> [17612.218666] sd 16:0:0:0: [sdb] No Caching mode page present
>> [17612.218672] sd 16:0:0:0: [sdb] Assuming drive cache: write through
>> [17612.218677] sd 16:0:0:0: [sdb] Attached SCSI removable disk
>> [17620.408767] usb 1-1.6: USB disconnect, device number 14
>> [17620.410224] scsi 16:0:0:0: killing request
>> [17620.410512] BUG: unable to handle kernel NULL pointer dereference
>> at 0000000000000008
>> [17620.411480] IP: [<ffffffffa01e08ef>] sd_revalidate_disk+0x3f/0x1a10 [sd_mod]
>> [17620.411501] PGD 286a3067 PUD aef9f067 PMD 0
>> [17620.411507] Oops: 0000 [#1] SMP
>> [17620.411512] CPU 0
>
> There's a patch to fix this that will hopefully be pulled into Linus' tree
> today.  It should work it's way back to 3.2-stable after that.
>

Could you just point out the patch (including the tree shipping it) so
I can use/test it ?

Thanks
-- 
Francis
