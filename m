Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab1IRW0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 18:26:21 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:6467 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab1IRW0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 18:26:20 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/3] Staging: hv: util: Perform some service specific
 init/deinit in probe/remove
Thread-Topic: [PATCH 1/3] Staging: hv: util: Perform some service specific
 init/deinit in probe/remove
Thread-Index: AQHMdiW8hLaXXnT3BkWPeihMm/tE45VT4LiA///VuVA=
Date: Sun, 18 Sep 2011 22:26:19 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081E781B@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1316367053-700-1-git-send-email-kys@microsoft.com>
	 <1316367095-739-1-git-send-email-kys@microsoft.com>
 <1316368394.4916.2.camel@Joe-Laptop>
In-Reply-To: <1316368394.4916.2.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8IMQTTF011878



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Sunday, September 18, 2011 1:53 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 1/3] Staging: hv: util: Perform some service specific
> init/deinit in probe/remove
> 
> On Sun, 2011-09-18 at 10:31 -0700, K. Y. Srinivasan wrote:
> > In preparation for modifying the util driver to fully conform to the
> > Linux Driver Model,
> []
> > diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
> []
> >  static const struct hv_vmbus_device_id id_table[] = {
> >  	/* Shutdown guid */
> >  	{ VMBUS_DEVICE(0x31, 0x60, 0x0B, 0X0E, 0x13, 0x52, 0x34, 0x49,
> > -		       0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB) },
> > +		       0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB)
> > +	  .driver_data = (unsigned long)&util_shutdown },
> 
> Isn't this a kernel_ulong_t ?

Yes; but kernel_ulong_t is unsigned long and this code is compiled only in the kernel.

Regards,

K. Y

> 
> > +	  .driver_data = (unsigned long)&util_timesynch },
> 
> etc.
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
