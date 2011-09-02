Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1IBQJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:09:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60047 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab1IBQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:09:28 -0400
X-Sasl-enc: brhejIRDeM+o0MpRHjkqYHMlq9i1CshqqVhhFxmHDR0Y 1314979767
Date: Fri, 2 Sep 2011 09:03:29 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Peter Foley <pefoley2@verizon.net>, "gregkh@suse.de" <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: Hyper-V TODO file
Message-ID: <20110902160329.GA4682@kroah.com>
References: <1314829011-28922-1-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1108311907130.20924@linux>
 <20110901203113.GA15259@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B5FA3@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B5FA3@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 03:17:19PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, September 01, 2011 4:31 PM
> > To: Peter Foley
> > Cc: KY Srinivasan; gregkh@suse.de; Linux Kernel Mailing List;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > Subject: Re: Hyper-V TODO file
> > 
> > On Wed, Aug 31, 2011 at 07:11:39PM -0400, Peter Foley wrote:
> > > On Wed, 31 Aug 2011, K. Y. Srinivasan wrote:
> > > > Greg, as I have been pestering you for some time now, we are very
> > interested in
> > > > exiting staging and we are willing to dedicate the necessary development
> > > > resources to address whatever issues that may still be pending. So, your help
> > > > in identifying what needs to be done will be greatly appreciated. To that end,
> > > > I think it will be useful to update the TODO file to reflect the current state of
> > > > the drivers. Let us know how we should proceed here.
> > >
> > > An issue I've come across in the hyper-v drivers is the forced modular
> > > build. You might want to see if the "depends on m" is still needed.
> > 
> > Ah, good point, KY, can you try this out and see if that can be changed?
> > If not, something is wrong and that needs to get fixed.
> 
> Just verified that we can build into the kernel (not as modules) all hyper-V
> drivers except hv_storvsc. hv_storvsc depends upon functionality that in my build 
> is being built as modules (SCSI etc.) and this is the reason why I could not build
> hv_storvsc as part of the kernel.

So 'make allyesconfig' with the module dependancy turned off doesn't
break the build?  If so, great.

> Greg, do you want me to submit a patch to Kconfig, getting rid of the module
> dependency (for hyperv-v drivers).

Yes please.

thanks,

greg k-h
