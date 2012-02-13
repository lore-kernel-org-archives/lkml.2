Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab2BMTqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:46:55 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:59502 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754569Ab2BMTqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:46:54 -0500
X-SpamScore: -18
X-BigFish: VS-18(zz9371I936eK542M1432N98dKzz1202hzz8275bh8275dhz2fh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>,
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
Thread-Index: AQHM53l7bNaLMVkRnEuVbUmiF0pdz5Y282MAgATPJAD//3pI0A==
Date: Mon, 13 Feb 2012 19:31:40 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B70D5E0@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1328825688-4337-1-git-send-email-kys@microsoft.com>
	 <20120210180212.GA605@kroah.com> <1329161318.20751.30.camel@dabdike>
In-Reply-To: <1329161318.20751.30.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1DJl0bG004056



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Monday, February 13, 2012 2:29 PM
> To: Greg KH
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the
> staging area
> 
> On Fri, 2012-02-10 at 10:02 -0800, Greg KH wrote:
> > On Thu, Feb 09, 2012 at 02:14:48PM -0800, K. Y. Srinivasan wrote:
> > > The storage driver (storvsc_drv.c) handles all block storage devices
> > > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > > staging tree for a while and this patch moves it out of the staging area.
> > >
> > > James was willing to apply this patch during the 3.3-rc phase and a decision
> > > was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> > > patches for 3.4. Now that Greg has applied all of the pending storvsc patches,
> > > I am sending this patch to move this driver out of staging. Based on James'
> > > recommendation, this patch gets rid of the unneeded files in the staging/hv
> > > directory.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > ---
> > >  drivers/scsi/Kconfig                       |    7 +++++++
> > >  drivers/scsi/Makefile                      |    3 +++
> > >  drivers/{staging/hv => scsi}/storvsc_drv.c |    0
> > >  drivers/staging/Kconfig                    |    2 --
> > >  drivers/staging/Makefile                   |    1 -
> > >  drivers/staging/hv/Kconfig                 |    5 -----
> > >  drivers/staging/hv/Makefile                |    3 ---
> > >  drivers/staging/hv/TODO                    |    5 -----
> > >  8 files changed, 10 insertions(+), 16 deletions(-)
> > >  rename drivers/{staging/hv => scsi}/storvsc_drv.c (100%)
> > >  delete mode 100644 drivers/staging/hv/Kconfig
> > >  delete mode 100644 drivers/staging/hv/Makefile
> > >  delete mode 100644 drivers/staging/hv/TODO
> >
> > James, can I add your Acked-by: for this patch?
> 
> Yes ... i finally managed to pull your tree down and verify it.
> 
> Acked-by: James Bottomley <JBottomley@Parallels.com>

Thank you.

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
