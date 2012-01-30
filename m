Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2A3DuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:50:08 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41549 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339Ab2A3DuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:50:06 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, Chao Xie <cxie4@marvell.com>
Date: Sun, 29 Jan 2012 19:48:46 -0800
Subject: RE: linux-next: Tree for Jan 24 (usb/otg/mv_otg)
Thread-Topic: linux-next: Tree for Jan 24 (usb/otg/mv_otg)
Thread-Index: Aczav0UMTVQx4zGnROWV5Li13qhhDAEQkRYw
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE1A17429E0D@SC-VEXCH4.marvell.com>
References: <20120124163055.3c99bca0d5dfd754a352fb02@canb.auug.org.au>
 <4F1EFA85.6040008@xenotime.net>
In-Reply-To: <4F1EFA85.6040008@xenotime.net>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0U3oQ0l032437

Hi Randy,
> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: 2012å¹´1æœˆ25æ—¥ 2:38
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; LKML; linux-usb; Chao Xie; Neil Zhang
> Subject: Re: linux-next: Tree for Jan 24 (usb/otg/mv_otg)
> 
> On 01/23/2012 09:30 PM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20120123:
> 
> 
> on i386:
> 
> ERROR: "usb_remove_hcd" [drivers/usb/otg/mv_otg.ko] undefined!
> ERROR: "usb_add_hcd" [drivers/usb/otg/mv_otg.ko] undefined!
> 
> 
> Full randconfig file is attached.
> 

Thanks for your information, the marvell otg driver is dependent on ehci driver.
I have submit a patch to add the dependence.
Thanks.

> 
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your
> code ***

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
