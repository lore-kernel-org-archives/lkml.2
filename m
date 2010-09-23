Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0IWVEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:04:10 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:43326 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0IWVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:04:08 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/1] Rename camel case variables in channel.c
Thread-Topic: [PATCH 1/1] Rename camel case variables in channel.c
Thread-Index: ActbXSVeNM8VuoYfSBWx7n8ZoE23BQAPS1IAAA4PeoA=
Date: Thu, 23 Sep 2010 21:04:02 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7289ED3968@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7289EBB57C@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <1285274468.25928.15.camel@Joe-Laptop>
In-Reply-To: <1285274468.25928.15.camel@Joe-Laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o8NL4INA025825

> From: Joe Perches [mailto:joe@perches.com]
> Sent: Thursday, September 23, 2010 4:41 PM
> > -	struct hv_monitor_page *monitorPage;
> > +	struct hv_monitor_page *monitorpage;
> 
> Some of these renames would be better with a "_" for
> the CamelCase conversions (ie: CamelCase -> camel_case).

Yes, for longer names I usually insert underscore. For example, 
I changed packetLenAligned to packetlen_aligned.

> > +	struct hv_monitor_page *monitorpage;
> > +	u8 monitorGroup = (u8)channel->OfferMsg.MonitorId / 32;
> > +	u8 monitorOffset = (u8)channel->OfferMsg.MonitorId % 32;
> 
> Why not convert these to monitor_(group|offset)?

That's a good catch. I will update it.

Thanks,

- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
