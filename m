Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab2GSOSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:18:01 -0400
Received: from mail.stepping-stone.ch ([194.176.109.206]:60858 "EHLO
	mail.stepping-stone.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2GSOSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:18:00 -0400
Message-ID: <50081701.80308@stepping-stone.ch>
Date: Thu, 19 Jul 2012 16:17:37 +0200
From: stepping stone GmbH <support@stepping-stone.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: adam radford <aradford@gmail.com>
CC: stepping stone GmbH <support@stepping-stone.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: Kernel crash with lspci -vv and SAS Controller LSI Logic / Symbios
 Logic MegaRAID SAS 9240
References: <5006D810.8090408@stepping-stone.ch> <CAHtARFEd4He1d8=TWBjCXJed-HGM+2XvidBbxe930faGUro2KQ@mail.gmail.com>
In-Reply-To: <CAHtARFEd4He1d8=TWBjCXJed-HGM+2XvidBbxe930faGUro2KQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Adam

It did not work (exact same behaviour) with a newer kernel (3.5-rc7). 
The problem was the firmware. After a upgrade it works; with older 
kernels too. Great thanks and sorry to bother you (all).

Greetings

David

Am 19.07.2012 02:39, schrieb adam radford:
> On 7/18/12, stepping stone GmbH <support@stepping-stone.ch> wrote:
> ...
>> a tail of lspci -vv http://pastebin.com/kjh8ig9q
>>
> PCI Config reads from lspci -vvv don't go through the megaraid_sas
> driver itself.
>
> It looks like your system hung up while trying to do a PCI Config read
> of Capabilities 0xd0: VPD (Vital Product Data).
>
> I have a 9240 controller, and with kernel 3.5.0-rc1, I can do lspci -vvv :
>
>          Capabilities: [d0] Vital Product Data
>                  Unknown small resource type 00, will not decode more.
>          Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
>                  Address: 0000000000000000  Data: 0000
>          Capabilities: [c0] MSI-X: Enable+ Count=15 Masked-
>                  Vector table: BAR=1 offset=00002000
>                  PBA: BAR=1 offset=00003800
>          Capabilities: [100] Advanced Error Reporting
>                  UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                  UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                  UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                  CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                  CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                  AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
>          Capabilities: [138] Power Budgeting <?>
>          Kernel driver in use: megaraid_sas
>          Kernel modules: megaraid_sas
>
> Can you reproduce with kernel 3.5.0-rcX ?  I would also try upgrading
> your controller firmware.
>
> -Adam

-- 
stepping stone GmbH
Neufeldstrasse 9
CH-3012 Bern

Telefon: +41 31 332 53 63
www.stepping-stone.ch
support@stepping-stone.ch

