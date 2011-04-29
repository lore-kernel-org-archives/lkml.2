Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157Ab1D2XWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:22:21 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:56926 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab1D2XWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:22:20 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Thread-Topic: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Thread-Index: AQHMBCwlOahkyDWQA0Cj/4uI6AAO6ZRxNFuA///EzKCAAef0AIAB4skAgACoXgD///wvcIAAiueA//+MbuA=
Date: Fri, 29 Apr 2011 23:22:14 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DF101@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-8-git-send-email-kys@microsoft.com>
 <20110426224545.GC31974@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110428002018.GC14294@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD55F@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110429151052.GC12142@suse.de>
 <6E21E5352C11B742B20C142EB499E0481DD842@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110429231421.GA24396@suse.de>
In-Reply-To: <20110429231421.GA24396@suse.de>
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
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, April 29, 2011 7:14 PM
> To: KY Srinivasan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Abhishek Kane (Mindtree Consulting
> PVT LTD)
> Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
> cleanup accordingly
> 
> On Fri, Apr 29, 2011 at 10:02:43PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@suse.de]
> > > Sent: Friday, April 29, 2011 11:11 AM
> > > To: KY Srinivasan
> > > Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; Haiyang Zhang; Abhishek Kane (Mindtree
> Consulting
> > > PVT LTD)
> > > Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
> > > cleanup accordingly
> > >
> > >
> > > Just resend it with some more comments as I explained, and the rest, and
> > > I'll queue them up when I get caught up on my patch queue (I only have
> > > 381 to get through, the end is near!)
> >
> > Done; I just resent the remaining patches with comments and corrections
> > you had recommended. With regards to asking for a review, should I wait until
> > all these patches are applied?
> 
> Yes, unless you know of any other changes you want to make to the vmbus
> core.

Thanks. Currently, I am not planning to make any changes to the vmbus core.

Regards,

K. Y



