Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960Ab2D0JWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 05:22:52 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46024 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2D0JWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 05:22:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120427091405.GS3157@wantstofly.org>
References: <1335517711-6522-1-git-send-email-sedat.dilek@gmail.com>
	<20120427091405.GS3157@wantstofly.org>
Date: Fri, 27 Apr 2012 11:22:49 +0200
Message-ID: <CA+icZUVAK3NHmbG5kR1KhqGe9mAimWWzLz-MfXOXbyry3Sz73w@mail.gmail.com>
Subject: Re: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 11:14 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Fri, Apr 27, 2012 at 11:08:31AM +0200, Sedat Dilek wrote:
>
>> User lautriv asked for belkin N-1 WLAN device support on IRC.
>>
>> Further informations from lautriv:
>> * marvell 80W8031, card-id 11ab:2a02
>> * Debian/sid 3.2.x
>>
>> On [1] I found a report by Jim Cromie concerning same PCI device-id:
>>
>> 00:0e.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
>> 88W8361 [TopDog] 802.11n Wireless [11ab:2a02] (rev 03)
>>       Subsystem: Marvell Technology Group Ltd. 88W8361 [TopDog] 802.11n Wireless [11ab:2a02]
>>
>> So, let's add 0x2a02 to PCI device table.
>
> Let's not.  There's no firmware for the 8361 that implements the
> firmware interface currently implemented by the mwl8k driver, so
> this is pretty useless.
>
>
>> [1] http://www.spinics.net/lists/newbies/msg46601.html
>
> From that link:
>
> | I have a card which modprobes, despite a PCI-ID mismatch
> |
> | [...]
> |
> | Given the pci-id mismatch shouldnt this just fail to modprobe ?
>
> No.  That's not a bug -- you are free to load drivers for hardware
> not currently in your system.
>
>
>>  static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
>> +     { PCI_VDEVICE(MARVELL, 0x2a02), .driver_data = MWL8363, },
>>       { PCI_VDEVICE(MARVELL, 0x2a0a), .driver_data = MWL8363, },
>
> A 8361 is certainly not a 8363.

Damn, I got confused by all the numbers. More coffee.
Thanks for the clarification. I will inform the user on IRC.
Sorry, for the noise.

Are you planning to or even working on support (for) 8361 devices?

- Sedat -
