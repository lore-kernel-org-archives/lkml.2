Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1GSWqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:46:18 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:17360 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1GSWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:46:17 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 5/8] Staging: hv: mousevsc: Fix checkpatch errors and
 warnings
Thread-Topic: [PATCH 5/8] Staging: hv: mousevsc: Fix checkpatch errors and
 warnings
Thread-Index: AQHMRkYCXNYtXGWSzkWJgTv6uD9TwZT0fOSA//+9F4A=
Date: Tue, 19 Jul 2011 22:46:15 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480817B2BB@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1311101018-23370-1-git-send-email-kys@microsoft.com>
	 <1311101065-23417-1-git-send-email-kys@microsoft.com>
	 <1311101065-23417-5-git-send-email-kys@microsoft.com>
 <1311103713.12882.13.camel@Joe-Laptop>
In-Reply-To: <1311103713.12882.13.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6JMkSNW009454



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, July 19, 2011 3:29 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 5/8] Staging: hv: mousevsc: Fix checkpatch errors and
> warnings
> 
> On Tue, 2011-07-19 at 11:44 -0700, K. Y. Srinivasan wrote:
> > Fix checkpatch errors and warnings.
> []
> > diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> []
> > @@ -53,7 +53,7 @@ struct hv_input_dev_info {
> > -#pragma pack(push,1)
> > +#pragma pack(push, 1)
> >  /*
> >   * Message types in the synthetic input protocol
> >   */
> 
> Perhaps it's better and more consistent with
> other kernel style uses to remove #pragma pack[...]
> and mark the individual structs with __packed;

Good point. Currently, this driver is not functional. When the driver
is finally functional, there is a whole lot of cleanup that is needed and I will
do what you are suggesting then. For this go around, I just wanted to address
checkpatch issues with minimal change.

Regards,

K. Y 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
