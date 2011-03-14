Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab1CNUN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:13:29 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:52262 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab1CNUN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:13:27 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 10/21] Staging: hv: Cleanup root device handling
Thread-Topic: [PATCH 10/21] Staging: hv: Cleanup root device handling
Thread-Index: AQHL325PocxW5f6Slk6ZU6fmhggziZQts+SA//+PD0CAAHgBgP//jBEQ
Date: Mon, 14 Mar 2011 20:13:26 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480195A8@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1299794886-1200-1-git-send-email-kys@microsoft.com>
 <20110314193333.GA18944@kroah.com>
 <6E21E5352C11B742B20C142EB499E048019582@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110314195849.GA533@suse.de>
In-Reply-To: <20110314195849.GA533@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Monday, March 14, 2011 3:59 PM
> To: KY Srinivasan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Mike Sterling; Abhishek Kane
> (Mindtree Consulting PVT LTD)
> Subject: Re: [PATCH 10/21] Staging: hv: Cleanup root device handling
> 
> On Mon, Mar 14, 2011 at 07:54:29PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Monday, March 14, 2011 3:34 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> Mike
> > > Sterling; Abhishek Kane (Mindtree Consulting PVT LTD)
> > > Subject: Re: [PATCH 10/21] Staging: hv: Cleanup root device handling
> > >
> > > On Thu, Mar 10, 2011 at 02:08:06PM -0800, K. Y. Srinivasan wrote:
> > > > Now we can complete the cleanup of the root device
> > > > management. Use the preferred APIs for creating and
> > > > managing the root device. As part of this cleanup get rid
> > > > of the root device object from vmbus_driver_context.
> > >
> > > I don't understand, what is the "root device"?
> >
> > This would be the device under /sys/devices that all
> > other hyperv devices would be grouped under.
> > This notion of the root device existed in the existing
> > code; however  its creation and management was
> > unnecessarily complicated.
> 
> But that is what your new pci device should be, not a separate one.  Why
> not use that instead?
> 
> Actually, how are things looking then?  You have a pci device, with no
> children, yet the root device has the children devices?  That doesn't
> really make sense now does it?

Good point. I will cleanup the patches and send you the updated ones shortly.

Regards,

K. Y


