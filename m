Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2BMT2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:28:46 -0500
Received: from mx2.parallels.com ([64.131.90.16]:60956 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab2BMT2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:28:43 -0500
From: James Bottomley <jbottomley@parallels.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "K. Y. Srinivasan" <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Topic: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Thread-Index: AQHM6oWvMdqbaW105EGi1dxxGQjqtA==
Date: Mon, 13 Feb 2012 19:28:38 +0000
Message-ID: <1329161318.20751.30.camel@dabdike>
References: <1328825688-4337-1-git-send-email-kys@microsoft.com>
	 <20120210180212.GA605@kroah.com>
In-Reply-To: <20120210180212.GA605@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [65.82.134.8]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F864D1A82274D24DBA6A882DE77342CC@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1DJSupa003968

On Fri, 2012-02-10 at 10:02 -0800, Greg KH wrote:
> On Thu, Feb 09, 2012 at 02:14:48PM -0800, K. Y. Srinivasan wrote:
> > The storage driver (storvsc_drv.c) handles all block storage devices
> > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > staging tree for a while and this patch moves it out of the staging area.
> > 
> > James was willing to apply this patch during the 3.3-rc phase and a decision
> > was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> > patches for 3.4. Now that Greg has applied all of the pending storvsc patches,
> > I am sending this patch to move this driver out of staging. Based on James'
> > recommendation, this patch gets rid of the unneeded files in the staging/hv
> > directory.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/Kconfig                       |    7 +++++++
> >  drivers/scsi/Makefile                      |    3 +++
> >  drivers/{staging/hv => scsi}/storvsc_drv.c |    0
> >  drivers/staging/Kconfig                    |    2 --
> >  drivers/staging/Makefile                   |    1 -
> >  drivers/staging/hv/Kconfig                 |    5 -----
> >  drivers/staging/hv/Makefile                |    3 ---
> >  drivers/staging/hv/TODO                    |    5 -----
> >  8 files changed, 10 insertions(+), 16 deletions(-)
> >  rename drivers/{staging/hv => scsi}/storvsc_drv.c (100%)
> >  delete mode 100644 drivers/staging/hv/Kconfig
> >  delete mode 100644 drivers/staging/hv/Makefile
> >  delete mode 100644 drivers/staging/hv/TODO
> 
> James, can I add your Acked-by: for this patch?

Yes ... i finally managed to pull your tree down and verify it.

Acked-by: James Bottomley <JBottomley@Parallels.com>

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
