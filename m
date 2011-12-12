Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1LLJJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:09:44 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:45593 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab1LLJJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:09:40 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 12 Dec 2011 10:09:10 +0100
Subject: RE: [PATCHv2 01/10] xshm: Shared Memory layout for ST-E M7400
 driver.
Thread-Topic: [PATCHv2 01/10] xshm: Shared Memory layout for ST-E M7400
 driver.
Thread-Index: Acy2gUTapoPFivvsTV23yGR5QYy13gCK+nBA
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0D6BA6E@EXDCVYMBSTM005.EQ1STM.local>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
 <1323439648-22697-2-git-send-email-sjur.brandeland@stericsson.com>
 <201112091445.56224.arnd@arndb.de>
In-Reply-To: <201112091445.56224.arnd@arndb.de>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBC99mcN017499

Hi Arnd,

> >  include/linux/xshm/xshm_ipctoc.h |  160
> ++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 160 insertions(+), 0 deletions(-)
> >  create mode 100644 include/linux/xshm/xshm_ipctoc.h
> 
> Generally, the include/linux path is for interfaces between modules, while
> hardware data structures should be in the same directory as the driver using
> them to provide an abstract interface.

Sure, I'll move this file to drivers/xshm.

> > +#pragma pack(1)
> 
> Better remove the #pragma. Marking data structures as packed when they
> are already packed to start with only leads to worse optimizations in the
> compiler, but does not have a functional impact.

Ok, I'll remove the #pragma in the next patch-set.

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
