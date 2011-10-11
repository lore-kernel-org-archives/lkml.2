Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1JKHJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:09:38 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:10131 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1JKHJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:09:37 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <a.miskiewicz@gmail.com>, <stefanb@linux.vnet.ibm.com>
CC: <m.selhorst@sirrix.com>, <tpmdd-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [tpmdd-devel] Linux 3.1-rc9
Thread-Topic: [tpmdd-devel] Linux 3.1-rc9
Thread-Index: AQHMhsU9m74BwT4/7k65B/XioNR54ZV0ubOAgADpEQCAAAvlAIAABIcAgAAJ4ICAAPzEoA==
Date: Tue, 11 Oct 2011 07:09:31 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440732DB@MUCSE501.eu.infineon.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	<201110101905.52769.a.miskiewicz@gmail.com>
	<4E9329BC.8030704@linux.vnet.ibm.com>
 <201110101957.25322.a.miskiewicz@gmail.com>
In-Reply-To: <201110101957.25322.a.miskiewicz@gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9B79ji0028582

-----Original Message-----
From: Arkadiusz MiÅ›kiewicz [mailto:a.miskiewicz@gmail.com]
>> I guess the BIOS seems not to be initializing the TPM correctly. Any
>> chance you can get a hold of a BIOS update for your machine?

> Then I looked into bios options on this thinkpad t400 and there are 3 possible
> TPM settings: Enabled, Invisible, Disabled.

> Invisible is - visible but not working - according to bios help. No idea why
> such option exists but I had it enabled.

> I guess there is some way to make "Invisible" mode properly handled in Linux,
> too.

Invisible here probably means that the bios simply does not send a TPM_Startup which is needed to get the TPM running.
(and maybe it even let's physical presence untouched too).
If the driver would send a TPM_Startup(STATE) (which usually should not cause any problems, since if you send it twice the second one simply gets 'ignored' with a "invalid postinit" return code)
the tpm would probably work in the invisible case too.


Thanks,
Peter



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
