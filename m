Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030643Ab2CBVb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:31:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab2CBVb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:31:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.231.133 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 2 Mar 2012 13:31:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
 the host
Message-ID: <20120302213116.GA23443@kroah.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
 <20120302211354.GB6008@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481B736783@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B736783@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 09:22:38PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, March 02, 2012 4:14 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org; ohering@suse.com; jbottomley@parallels.com;
> > hch@infradead.org; linux-scsi@vger.kernel.org; Haiyang Zhang
> > Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> > the host
> > 
> > On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> > > Windows hosts don't handle the ATA_16 command; don't pass it to the host.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/scsi/storvsc_drv.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > Should this go to older kernel versions as well?
> 
> I think it should. Do you want me to resend this patch with the correct tag?
> Also, given that storvsc has changed so much over the last several months,
> this patch may or may not apply to earlier versions of this driver even though
> this patch itself is quite trivial.

I'll tag it for the stable tree, then when it doesn't apply, you will
get an email saying it didn't, so you can then send me the correct one
:)

thanks,

greg k-h
