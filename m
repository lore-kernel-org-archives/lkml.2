Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1DLN2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 09:28:19 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1990 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1DLN2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 09:28:18 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "George Kashperko" <george@znau.edu.ua>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        "Andy Botting" <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
 <BANLkTi=jV12tOR_=idn0z+oO_RQ2xaFhCQ@mail.gmail.com>
 <op.vtttxt083ri7v4@arend-laptop>
 <BANLkTiksJmiiK53kcP6vm6CTmzXhQa7oTA@mail.gmail.com>
Date: Tue, 12 Apr 2011 15:27:59 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vttucxh73ri7v4@arend-laptop>
In-Reply-To: <BANLkTiksJmiiK53kcP6vm6CTmzXhQa7oTA@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 61BA8BA33GO1467773-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 15:21:44 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> 2011/4/12 Arend van Spriel <arend@broadcom.com>:
>> On Tue, 12 Apr 2011 15:04:48 +0200, Rafał Miłecki <zajec5@gmail.com>  
>> wrote:
>>
>>> There is one more change I started to consider. Is "core" correct name
>>> for AXI's device? Almost everywhere we can read about *components* on
>>> the AXI interconnect.
>>>
>>> Maybe it'd make sense to s/core/comp/? Arend?
>>
>> I have no strong preference on this. I tried the latest patch and it  
>> does
>> not crash anymore with load/unload.
>
> Could you post dmesg? Probably nothing exciting, just my curiosity :)
>
Apr 12 11:56:52 arend-laptop kernel: [ 6615.077417] axi-pci-bridge  
0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Apr 12 11:56:52 arend-laptop kernel: [ 6615.078690] axi: Core 0 found:  
ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
Apr 12 11:56:52 arend-laptop kernel: [ 6615.079215] axi: Core 1 found:  
IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
Apr 12 11:56:52 arend-laptop kernel: [ 6615.079777] axi: Core 2 found:  
PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
Apr 12 11:56:52 arend-laptop kernel: [ 6615.111608] axi: AXI registered
Apr 12 11:57:25 arend-laptop kernel: [ 6648.556024] axi-pci-bridge  
0000:03:00.0: PCI INT A disabled

Happy to satisfy your curiosity.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

