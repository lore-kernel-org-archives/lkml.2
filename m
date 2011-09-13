Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1IMSPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:15:33 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:6273 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab1IMSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:15:30 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 20/20] Staging: hv: netvsc: Rename deviceInfo as
 device_info
Thread-Topic: [PATCH 20/20] Staging: hv: netvsc: Rename deviceInfo as
 device_info
Thread-Index: AQHMcjvrT3mD7dsep06ayBqlnNU7fpVMEbmA//+L1aA=
Date: Tue, 13 Sep 2011 18:15:28 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081E4C60@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
	 <1315936796-20662-1-git-send-email-kys@microsoft.com>
	 <1315936796-20662-20-git-send-email-kys@microsoft.com>
 <1315937432.25776.9.camel@Joe-Laptop>
In-Reply-To: <1315937432.25776.9.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8DIFihN018141



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, September 13, 2011 2:11 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 20/20] Staging: hv: netvsc: Rename deviceInfo as
> device_info
> 
> On Tue, 2011-09-13 at 10:59 -0700, K. Y. Srinivasan wrote:
> > Rename deviceInfo as device_info.
> []
> > diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
> []
> > @@ -732,15 +732,15 @@ int rndis_filter_device_add(struct hv_device *dev,
> []
> >  	dev_info(&dev->device, "Device MAC %pM link state %s",
> >  		 rndis_device->hw_mac_adr,
> > -		 ((deviceInfo->link_state) ? ("down\n") : ("up\n")));
> > +		 ((device_info->link_state) ? ("down\n") : ("up\n")));
> 
> Maybe get rid of the superfluous parentheses too?
> 
> 	dev_info(&dev->device, "Device MAC %pM link state %s\n",
> 		 rndis_device->hw_mac_adr,
> 		 device_info->link_state ? "down" : "up");
> 
> Also, struct rndis_device uses
> 	u32 link_stat;
> that is copied into struct netvsc_device_info
> 	bool link_state;
> could you please rationalize the names and types
> of those 2 variables?

Thanks Joe; I will get a patch out soon.

Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
