Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab0JYXdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:33:14 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:17105
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab0JYXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:33:12 -0400
X-SpamScore: 1
X-BigFish: VS1(z37d4lz4015Lzz1202hzz1497iz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [GIT PATCH] USB patches for .37-rc1
Date: Mon, 25 Oct 2010 16:33:27 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851051D62E6@az33exm21>
In-Reply-To: <20101022175102.GA13489@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [GIT PATCH] USB patches for .37-rc1
Thread-Index: ActyEd3x1iiJpbgQTAib3AqMdT72UgCiocpg
References: <20101022175102.GA13489@kroah.com>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Greg KH <gregkh@suse.de>, <matthieu.castet@parrot.com>,
        <stern@rowland.harvard.edu>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9PNXSWQ006292

Hi Greg,

It seems that this commit is breaking ehci-mxc build for MX51.

USB: ehci tdi : let's tdi_reset set host mode
Commit # 65fd42724aee31018b0bb53f4cb04971423be664

>Matthew Garrett (1):
>      USB: serial: Enable USB autosuspend by default on qcserial
>

The error is:

drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first use in this function)

Thanks,

Dinh Nguyen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
