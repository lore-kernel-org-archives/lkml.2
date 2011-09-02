Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1IBPRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:17:21 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:17279 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1IBPRU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:17:20 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>, Peter Foley <pefoley2@verizon.net>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: Hyper-V TODO file
Thread-Topic: Hyper-V TODO file
Thread-Index: AQHMaDPOS/BsfL6FREeXxxnZwadf6JU5cR+AgAC/xVA=
Date: Fri, 2 Sep 2011 15:17:19 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B5FA3@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314829011-28922-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1108311907130.20924@linux>
 <20110901203113.GA15259@kroah.com>
In-Reply-To: <20110901203113.GA15259@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, September 01, 2011 4:31 PM
> To: Peter Foley
> Cc: KY Srinivasan; gregkh@suse.de; Linux Kernel Mailing List;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: Hyper-V TODO file
> 
> On Wed, Aug 31, 2011 at 07:11:39PM -0400, Peter Foley wrote:
> > On Wed, 31 Aug 2011, K. Y. Srinivasan wrote:
> > > Greg, as I have been pestering you for some time now, we are very
> interested in
> > > exiting staging and we are willing to dedicate the necessary development
> > > resources to address whatever issues that may still be pending. So, your help
> > > in identifying what needs to be done will be greatly appreciated. To that end,
> > > I think it will be useful to update the TODO file to reflect the current state of
> > > the drivers. Let us know how we should proceed here.
> >
> > An issue I've come across in the hyper-v drivers is the forced modular
> > build. You might want to see if the "depends on m" is still needed.
> 
> Ah, good point, KY, can you try this out and see if that can be changed?
> If not, something is wrong and that needs to get fixed.

Just verified that we can build into the kernel (not as modules) all hyper-V
drivers except hv_storvsc. hv_storvsc depends upon functionality that in my build 
is being built as modules (SCSI etc.) and this is the reason why I could not build
hv_storvsc as part of the kernel.

Greg, do you want me to submit a patch to Kconfig, getting rid of the module
dependency (for hyperv-v drivers).

Regards,

K. Y

