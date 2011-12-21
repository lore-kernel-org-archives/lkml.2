Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1LUAnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:43:00 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:4970
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485Ab1LUAm6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:42:58 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275bh8275dhz2fh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-FB-SS: 13,
From: KY Srinivasan <kys@microsoft.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage
 driver out of the staging area
Thread-Topic: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage
 driver out of the staging area
Thread-Index: AQHMv0gomzY6ZHnGM0GWEtF+9I8RfZXl340A//+Uc3A=
Date: Wed, 21 Dec 2011 00:42:52 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B286840@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1324407064-16875-1-git-send-email-kys@microsoft.com>
 <CAA9_cmf2RQapBD3th-RAhhTBB64N9ChKNFNXz0PEZJexeQUoqw@mail.gmail.com>
In-Reply-To: <CAA9_cmf2RQapBD3th-RAhhTBB64N9ChKNFNXz0PEZJexeQUoqw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.74]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On Behalf Of
> Dan Williams
> Sent: Tuesday, December 20, 2011 6:06 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> James.Bottomley@hansenpartnership.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage driver
> out of the staging area
> 
> On Tue, Dec 20, 2011 at 10:51 AM, K. Y. Srinivasan <kys@microsoft.com> wrote:
> > The storage driver (storvsc_drv.c) handles all block storage devices
> > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > staging tree for a while and this patch moves it out of the staging area.
> > As per Greg's recommendation, this patch makes no changes to the staging/hv
> > directory. Once the driver moves out of staging, we will cleanup the
> > staging/hv directory.
> >
> > This patch includes all the patches that I have sent against the staging/hv
> > tree to address the comments I have gotten to date on this storage driver.
> > Greg has already applied all these patches to the staging tree.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/Kconfig       |    7 +
> >  drivers/scsi/Makefile      |    3 +
> >  drivers/scsi/storvsc_drv.c | 1586
> ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 1596 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/scsi/storvsc_drv.c
> 
> Shouldn't this diffstat be something like the following?
> 
>  drivers/scsi/Kconfig                       |    7 +
>  drivers/scsi/Makefile                      |    3 +
>  drivers/{staging/hv => scsi}/storvsc_drv.c |  310 +++++++++++++++++++---------
>  3 files changed, 218 insertions(+), 102 deletions(-)
>  rename drivers/{staging/hv => scsi}/storvsc_drv.c (87%)

As per Greg's suggestion, this patch does not remove the driver from
the staging tree. Once the driver lands in the correct directory, we will
remove the driver from the staging directory.

Regards,

K. Y

