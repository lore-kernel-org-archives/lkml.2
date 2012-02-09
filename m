Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2BIQnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:43:12 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:7294 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2BIQnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:43:09 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <gregkh@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/2] Staging: hv: Applied all the patches already in the
 staging queue
Thread-Topic: [PATCH 1/2] Staging: hv: Applied all the patches already in
 the staging queue
Thread-Index: AQHM3FDeCPcI7MXkNkGSexSU4QdONpYfb+6AgAADmQCAFVK60IAAl0QA//98KuA=
Date: Thu, 9 Feb 2012 16:42:28 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B70C91F@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
 <1327599515-12679-1-git-send-email-kys@microsoft.com>
 <20120126173751.GA14400@suse.de>
 <1327600244.6151.5.camel@dabdike.int.hansenpartnership.com>
 <6E21E5352C11B742B20C142EB499E0481B70C8A1@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20120209162940.GA16395@kroah.com>
In-Reply-To: <20120209162940.GA16395@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, February 09, 2012 11:30 AM
> To: KY Srinivasan
> Cc: James Bottomley; Greg KH; linux-scsi@vger.kernel.org; ohering@suse.com;
> linux-kernel@vger.kernel.org; hch@infradead.org; virtualization@lists.osdl.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the staging
> queue
> 
> On Thu, Feb 09, 2012 at 03:31:50PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > > Sent: Thursday, January 26, 2012 12:51 PM
> > > To: Greg KH
> > > Cc: KY Srinivasan; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; ohering@suse.com; hch@infradead.org; linux-
> > > scsi@vger.kernel.org
> > > Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the
> staging
> > > queue
> > >
> > > > Yes, I have pending patches for this driver in my "to-apply" queue, but
> > > > that is for 3.4, not now.
> > > >
> > > > So, how about I just apply those patches, and then apply a patch that
> > > > moves it out of staging into drivers/scsi/, and queue all of those up
> > > > for 3.4.
> > > >
> > > > James, any objection to that?
> > >
> > > Well, we were going to try to stage this driver for 3.3-rc.  If everyone
> > > agrees to push it back to 3.4, then this works for me.
> >
> > Greg,
> >
> > Now that you have applied all the pending patches for the Hyper-V storage
> > driver; do you want me to resend the patch that moved this driver out of
> staging?
> 
> Please do, I need James's ACK on it as well.

I will re-send the patch that James was about to apply a few weeks ago for 3.3-rc.
James, do you need something else to ACK this.

Regards,

K. Y


