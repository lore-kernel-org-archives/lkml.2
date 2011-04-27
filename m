Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1D0Bzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:55:33 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:32840 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab1D0Bzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:55:32 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 11/25] Staging: hv: Get rid of the drv field in struct
 hv_device
Thread-Topic: [PATCH 11/25] Staging: hv: Get rid of the drv field in struct
 hv_device
Thread-Index: AQHMBCwlgVfyNaSCeki1+kuhaF0qSJRxN2WA//+8VVA=
Date: Wed, 27 Apr 2011 01:55:31 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD195@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-11-git-send-email-kys@microsoft.com>
 <20110426225637.GB12897@kroah.com>
In-Reply-To: <20110426225637.GB12897@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, April 26, 2011 6:57 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Abhishek Kane (Mindtree Consulting PVT LTD); Hank Janssen
> Subject: Re: [PATCH 11/25] Staging: hv: Get rid of the drv field in struct hv_device
> 
> On Tue, Apr 26, 2011 at 09:20:28AM -0700, K. Y. Srinivasan wrote:
> > Now, we can rid of the drv field in struct hv_device.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > ---
> >  drivers/staging/hv/vmbus_api.h |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
> > index 51fa952..02e3587 100644
> > --- a/drivers/staging/hv/vmbus_api.h
> > +++ b/drivers/staging/hv/vmbus_api.h
> > @@ -103,9 +103,6 @@ struct hv_driver {
> >
> >  /* Base device object */
> >  struct hv_device {
> > -	/* the driver for this device */
> > -	struct hv_driver *drv;
> > -
> >  	char name[64];
> 
> FYI, in the future, you can also remove this name[64] field as well as I
> don't think it's ever used...

I will send you a patch for this, once all the patches in this series are applied.

Regards,

K. Y


