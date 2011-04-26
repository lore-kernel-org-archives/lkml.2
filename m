Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab1DZWMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:12:18 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:21276 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1DZWMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:12:16 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH 18/25] Staging: hv: Get rid of struct hv_bus
Thread-Topic: [PATCH 18/25] Staging: hv: Get rid of struct hv_bus
Thread-Index: AQHMBCwn1s6JBZAG00mF/Gjulq2PA5RxAJqA//+U6ACAAIDEgP//nuKA
Date: Tue, 26 Apr 2011 22:12:15 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD0B4@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-18-git-send-email-kys@microsoft.com>
 <20110426194031.GD17467@suse.de>
 <6E21E5352C11B742B20C142EB499E0481DD061@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110426205805.GC20381@suse.de>
In-Reply-To: <20110426205805.GC20381@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, April 26, 2011 4:58 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Abhishek Kane (Mindtree Consulting
> PVT LTD); Hank Janssen
> Subject: Re: [PATCH 18/25] Staging: hv: Get rid of struct hv_bus
> 
> On Tue, Apr 26, 2011 at 08:23:25PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@suse.de]
> > > Sent: Tuesday, April 26, 2011 3:41 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; Haiyang Zhang; Abhishek Kane (Mindtree
> Consulting
> > > PVT LTD); Hank Janssen
> > > Subject: Re: [PATCH 18/25] Staging: hv: Get rid of struct hv_bus
> > >
> > > On Tue, Apr 26, 2011 at 09:20:35AM -0700, K. Y. Srinivasan wrote:
> > > > Now, get rid of struct hv_bus. We will no longer be embedding
> > > > struct bus_type.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> > > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > > > ---
> > > >  drivers/staging/hv/vmbus_drv.c |   33 ++++++++++++++-------------------
> > > >  1 files changed, 14 insertions(+), 19 deletions(-)
> > > >
> > > >
> > > > -	hv_bus.bus.name = driver_name;
> > > > +	hv_bus.name = driver_name;
> > >
> > > Why are you setting the name of the bus again?  Shouldn't this line be
> > > removed?
> >
> > You are absolutely right. Since this redundancy was in the existing
> > code, should I send you a separate patch to fix this?
> 
> A separate one after this series is fine.

Done; I have sent the patch out.

Regards,

K. Y


