Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1GVOWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:22:50 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:24752 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1GVOWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:22:49 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: Hank Janssen <hjanssen@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 2/9] staging: hv: add newline to log messages in netvsc
Thread-Topic: [PATCH 2/9] staging: hv: add newline to log messages in netvsc
Thread-Index: AQHMR8duB/3AvyD8w0ux3psJBKL3xJT4BSIAgABge7A=
Date: Fri, 22 Jul 2011 14:22:48 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC09657C75@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1311268497-8671-1-git-send-email-haiyangz@microsoft.com>
	 <1311268497-8671-3-git-send-email-haiyangz@microsoft.com>
 <1311298545.21930.3.camel@Joe-Laptop>
In-Reply-To: <1311298545.21930.3.camel@Joe-Laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6MEN2eS020870

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Thursday, July 21, 2011 9:36 PM
> Just noticing some trivial typos...
> 
> > diff --git a/drivers/staging/hv/netvsc.c
> b/drivers/staging/hv/netvsc.c
> []
> > @@ -246,7 +246,7 @@ static int netvsc_init_recv_buf(struct hv_device
> *device)
> >  	if (init_packet->msg.v1_msg.
> >  	    send_recv_buf_complete.status != NVSP_STAT_SUCCESS) {
> >  		dev_err(&device->device, "Unable to complete receive buffer
> "
> > -			   "initialzation with NetVsp - status %d",
> > +			   "initialzation with NetVsp - status %d\n",
> 
> initialization
> 
> []
> > @@ -738,7 +738,7 @@ static void netvsc_receive(struct hv_device
> *device,
> >
> >  	if (xferpage_packet->count != vmxferpage_packet->range_cnt) {
> >  		dev_err(&device->device, "Needed %d netvsc pkts to satisy "
> > -			"this xfer page...got %d",
> > +			"this xfer page...got %d\n",
> 
> satisfy

Good catch! I will make a new patch to correct them.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
