Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab1H3RD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:03:59 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:30723 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1H3RD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:03:58 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
 connection.c
Thread-Topic: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
 connection.c
Thread-Index: AQHMZOS6S19CXS4DvkWhhuBTQVevgJUySuMAgANYjYA=
Date: Tue, 30 Aug 2011 17:03:57 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B52E4@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
	 <1314469905-7058-1-git-send-email-kys@microsoft.com>
	 <1314469905-7058-44-git-send-email-kys@microsoft.com>
 <1314514612.6852.11.camel@Joe-Laptop>
In-Reply-To: <1314514612.6852.11.camel@Joe-Laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7UH4Bo2027482



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Sunday, August 28, 2011 2:57 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
> connection.c
> 
> On Sat, 2011-08-27 at 11:31 -0700, K. Y. Srinivasan wrote:
> > Fix checkpatch warnings in connection.c.
> []
> > diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
> []
> > @@ -220,11 +220,11 @@ static void process_chn_event(u32 relid)
> >  	channel = relid2channel(relid);
> >
> >  	spin_lock_irqsave(&channel->inbound_lock, flags);
> > -	if (channel && (channel->onchannel_callback != NULL)) {
> > +	if (channel && (channel->onchannel_callback != NULL))
> 
> Useless test for channel or bad placement for spin_lock.
> channel has already been dereferenced by the spin_lock.
> 
> 
Thanks Joe. I will fix this up.

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
