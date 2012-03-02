Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab2CBVdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:33:15 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:16021
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab2CBVdN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:33:13 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275bh8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Index: AQHM+LUYOjJW5Du7G0WJSaUrHj4mnJZXgVQAgAABJ6CAAAOzAIAAAD8A
Date: Fri, 2 Mar 2012 21:33:00 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B73679D@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
 <20120302211354.GB6008@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481B736783@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20120302213116.GA23443@kroah.com>
In-Reply-To: <20120302213116.GA23443@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, March 02, 2012 4:31 PM
> To: KY Srinivasan
> Cc: linux-scsi@vger.kernel.org; Haiyang Zhang; ohering@suse.com;
> jbottomley@parallels.com; linux-kernel@vger.kernel.org; hch@infradead.org;
> virtualization@lists.osdl.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On Fri, Mar 02, 2012 at 09:22:38PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Friday, March 02, 2012 4:14 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; ohering@suse.com; jbottomley@parallels.com;
> > > hch@infradead.org; linux-scsi@vger.kernel.org; Haiyang Zhang
> > > Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> > > the host
> > >
> > > On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> > > > Windows hosts don't handle the ATA_16 command; don't pass it to the
> host.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > ---
> > > >  drivers/scsi/storvsc_drv.c |    2 ++
> > > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > >
> > > Should this go to older kernel versions as well?
> >
> > I think it should. Do you want me to resend this patch with the correct tag?
> > Also, given that storvsc has changed so much over the last several months,
> > this patch may or may not apply to earlier versions of this driver even though
> > this patch itself is quite trivial.
> 
> I'll tag it for the stable tree, then when it doesn't apply, you will
> get an email saying it didn't, so you can then send me the correct one
> :)

Thanks Greg.

K. Y


