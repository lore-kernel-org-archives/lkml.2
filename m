Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689Ab0COS52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:57:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57538
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965653Ab0COS51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:57:27 -0400
Date: Mon, 15 Mar 2010 11:57:48 -0700 (PDT)
Message-Id: <20100315.115748.13754030.davem@davemloft.net>
To: joern@dublin.logfs.org
Cc: hancockrwd@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Regression] r8169: enable 64-bit DMA by default for PCI
 Express devices (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100315151041.GA15667@Dublin.logfs.org>
References: <20100315150806.GA15354@Dublin.logfs.org>
	<20100315151041.GA15667@Dublin.logfs.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2FIvZmE016364

From: JÃ¶rn Engel <joern@dublin.logfs.org>
Date: Mon, 15 Mar 2010 16:10:41 +0100

> Forgot to Cc: lkml.

Actually, what you really need to CC: is netdev, added.
> On Mon, 15 March 2010 16:08:06 +0100, Jï¿½rn Engel wrote:
>> 
>> Hello Robert!
>> 
>> Looks like 353176888386d9025062a12dcec08d49af10cf2c broke one of my
>> machines.  Reverting that patch fixes things again.  Machine is
>> running an x86_64 kernel.  Lspci gives me this:
>> 
>> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
>>         Subsystem: ASRock Incorporation Device 8136
>>         Flags: bus master, fast devsel, latency 0, IRQ 26
>>         I/O ports at e800 [size=256]
>>         Memory at fdeff000 (64-bit, prefetchable) [size=4K]
>>         Memory at fdee0000 (64-bit, prefetchable) [size=64K]
>>         [virtual] Expansion ROM at fde00000 [disabled] [size=128K]
>>         Capabilities: [40] Power Management version 3
>>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>         Capabilities: [70] Express Endpoint, MSI 01
>>         Capabilities: [ac] MSI-X: Enable- Count=2 Masked-
>>         Capabilities: [cc] Vital Product Data
>>         Capabilities: [100] Advanced Error Reporting
>>         Capabilities: [140] Virtual Channel <?>
>>         Capabilities: [160] Device Serial Number 08-00-00-00-ff-ff-00-00
>>         Kernel driver in use: r8169
>> 
>> If you have any test patches to try, please send them my way. :)
>> 
>> Jï¿½rn
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
