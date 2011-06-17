Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab1FQQsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:48:36 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:16593 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab1FQQsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:48:35 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jun 2011 12:48:35 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Nicolas Kaiser <nikai@nikai.net>
CC: Hank Janssen <hjanssen@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 1/5] staging: hv: fix some white spaces in netvsc driver
Thread-Topic: [PATCH 1/5] staging: hv: fix some white spaces in netvsc driver
Thread-Index: AQHMLP/uDdLRlnLWHEWp07cb9gfSSpTCK4UA//+VCcA=
Date: Fri, 17 Jun 2011 16:43:27 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC09612D20@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
 <20110617180324.1eeb2ea0@absol.kitzblitz>
In-Reply-To: <20110617180324.1eeb2ea0@absol.kitzblitz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Nicolas Kaiser [mailto:nikai@nikai.net]
> Sent: Friday, June 17, 2011 12:03 PM
> To: Haiyang Zhang
> Cc: Hank Janssen; KY Srinivasan; Abhishek Kane (Mindtree Consulting
> PVT LTD); gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 1/5] staging: hv: fix some white spaces in netvsc
> driver
> 
> * Haiyang Zhang <haiyangz@microsoft.com>:
> > diff --git a/drivers/staging/hv/netvsc.c
> b/drivers/staging/hv/netvsc.c
> > index 0ae35e7..b6e1fb9 100644
> > --- a/drivers/staging/hv/netvsc.c
> > +++ b/drivers/staging/hv/netvsc.c
> > @@ -525,10 +525,10 @@ int netvsc_send(struct hv_device *device,
> >  						  (unsigned long)packet);
> >  	} else {
> >  		ret = vmbus_sendpacket(device->channel, &sendMessage,
> > -				       sizeof(struct nvsp_message),
> > -				       (unsigned long)packet,
> > -				       VM_PKT_DATA_INBAND,
> > -
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> > +				sizeof(struct nvsp_message),
> > +				(unsigned long)packet,
> > +				VM_PKT_DATA_INBAND,
> > +				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> 
> Why? The arguments were nicely aligned.

Because the last line went beyond 80 chars, and triggered checkpatch warning.

Thanks,
-Haiyang
