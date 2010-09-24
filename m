Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab0IXQIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:08:13 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:49384 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0IXQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:08:12 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>
Subject: RE: [PATCH 1/1] Rename camel case variables in channel.c  (updated)
Thread-Topic: [PATCH 1/1] Rename camel case variables in channel.c  (updated)
Thread-Index: ActbazpiIW5evuV4R4i5lbZ6gtNChQAP29QAABX0+7A=
Date: Fri, 24 Sep 2010 16:08:10 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7289EDBCAD@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7289ED89CF@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <1285281486.25928.31.camel@Joe-Laptop>
In-Reply-To: <1285281486.25928.31.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o8OG8LGK032268

> From: Joe Perches [mailto:joe@perches.com]
> Sent: Thursday, September 23, 2010 6:38 PM
> > +	struct vmbus_channel_gpadl_header *gpal_header;
> > +	struct vmbus_channel_gpadl_body *gpadl_body;
> > +	struct vmbus_channel_msginfo *msgheader;
> > +	struct vmbus_channel_msginfo *msgbody = NULL;
> > +	u32 msgsize;
> 
> Why gpal_header and not gpadl_header?

I have sent out an updated patch.

Thanks,

- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
