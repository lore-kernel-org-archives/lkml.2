Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2BIUgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:36:49 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:18395
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757857Ab2BIUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:36:48 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371I936eK542M1432N98dKzz1202hzz8275bh8275dhz2fh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Index: AQHM52VkUL8chIbTFkGkSHe4oNGmRZY1g0MAgAAEEgD//3pQ8A==
Date: Thu, 9 Feb 2012 20:21:36 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B70CB0A@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1328817851-13435-1-git-send-email-kys@microsoft.com>
	 <20120209200404.GA8816@kroah.com>
 <1328818718.2944.20.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1328818718.2944.20.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q19KaxNb012983



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thursday, February 09, 2012 3:19 PM
> To: Greg KH
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> staging area
> 
> On Thu, 2012-02-09 at 12:04 -0800, Greg KH wrote:
> > On Thu, Feb 09, 2012 at 12:04:11PM -0800, K. Y. Srinivasan wrote:
> > > The storage driver (storvsc_drv.c) handles all block storage devices
> > > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > > staging tree for a while and this patch moves it out of the staging area.
> > > As per Greg's recommendation, this patch makes no changes to the
> staging/hv
> > > directory. Once the driver moves out of staging, we will cleanup the
> > > staging/hv directory.
> > >
> > > James was willing to apply this patch during the 3.3-rc phase and a decision
> > > was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> > > patches for 3.4. Now that Greg has applied all of the pending storvsc patches,
> > > I am re-sending this patch to move this driver out of staging.
> > >
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > ---
> > >  drivers/scsi/Kconfig       |    7 +
> > >  drivers/scsi/Makefile      |    3 +
> > >  drivers/scsi/storvsc_drv.c | 1548
> ++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 1558 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/scsi/storvsc_drv.c
> >
> > James, any objection to me applying this to the staging-next tree, and
> > at the same time, deleting this version of the driver from the
> > drivers/staging/hv/ directory?
> 
> Well, yes, it has the same build failure as the previous one and that
> will make it non bisectable.

James,

What build failure is this. I just pulled down Greg's tree earlier today and applied this
patch and built it.

Regards,

K. Y 
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
