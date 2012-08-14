Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2HNBgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:36:25 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:40702 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2HNBgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:36:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1344908183!7371428!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Mon, 13 Aug 2012 20:36:22 -0500
Subject: RE: [PATCH 1/2 v2] staging: comedi: new adl_pci7x3x driver
Thread-Topic: [PATCH 1/2 v2] staging: comedi: new adl_pci7x3x driver
Thread-Index: Ac15vE9Ige8VjotNRhWd5tnrsSzKhQAAEx9g
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AAE977F3@AUSP01VMBX24.collaborationhost.net>
References: <201208031028.18759.hartleys@visionengravers.com>
 <20120814012949.GA11859@kroah.com>
In-Reply-To: <20120814012949.GA11859@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7E1aUx4013377

On Monday, August 13, 2012 6:30 PM, Greg KH wrote:
> On Fri, Aug 03, 2012 at 10:28:18AM -0700, H Hartley Sweeten wrote:
>> Currently the ADLink PCI-7230 and PCI-7432 Isolated Digital
>> I/O Boards are supported using two drivers (adl_pci7230 and
>> adl_pci7432). These drivers are very similar and only differ
>> in the total number of di/do channels provided.
>> 
>> This driver combines the support for both boards into one
>> common driver. In addition, it adds PCI PnP support for the
>> other boards in the ADLink PCI-723x and PCI-743x series.
>> 
>> This driver only supports the comedi PCI auto config attach
>> mechanism. The legacy attach using the comedi_config utility
>> is not supported or required by this driver.
>
> I now get the following build warnings on my box with this patch
> applied:
>
> drivers/staging/comedi/drivers/adl_pci7x3x.c: In function â€˜adl_pci7x3x_do_insn_bitsâ€™:
> drivers/staging/comedi/drivers/adl_pci7x3x.c:124:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> drivers/staging/comedi/drivers/adl_pci7x3x.c: In function â€˜adl_pci7x3x_di_insn_bitsâ€™:
> drivers/staging/comedi/drivers/adl_pci7x3x.c:150:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Hmm.. My build does not have the [-Wpointer-to-int-cast] for some reason
so I didn't see this. I was trying to save having to allocate any private data but
I guess it's cleaner if I do.  BTW, there is another comedi driver that does this
but I can't recall which one of the top of my head...

> Care to send a follow-on patch to fix this up?

Not a problem.

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
