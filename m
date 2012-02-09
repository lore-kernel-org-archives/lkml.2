Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab2BIUSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:18:41 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51660 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124Ab2BIUSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:18:40 -0500
Message-ID: <1328818718.2944.20.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, hch@infradead.org, linux-scsi@vger.kernel.org
Date: Thu, 09 Feb 2012 14:18:38 -0600
In-Reply-To: <20120209200404.GA8816@kroah.com>
References: <1328817851-13435-1-git-send-email-kys@microsoft.com>
	 <20120209200404.GA8816@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 12:04 -0800, Greg KH wrote:
> On Thu, Feb 09, 2012 at 12:04:11PM -0800, K. Y. Srinivasan wrote:
> > The storage driver (storvsc_drv.c) handles all block storage devices
> > assigned to Linux guests hosted on Hyper-V. This driver has been in the
> > staging tree for a while and this patch moves it out of the staging area.
> > As per Greg's recommendation, this patch makes no changes to the staging/hv
> > directory. Once the driver moves out of staging, we will cleanup the
> > staging/hv directory.
> > 
> > James was willing to apply this patch during the 3.3-rc phase and a decision
> > was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> > patches for 3.4. Now that Greg has applied all of the pending storvsc patches,
> > I am re-sending this patch to move this driver out of staging.
> > 
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/Kconfig       |    7 +
> >  drivers/scsi/Makefile      |    3 +
> >  drivers/scsi/storvsc_drv.c | 1548 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 1558 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/scsi/storvsc_drv.c
> 
> James, any objection to me applying this to the staging-next tree, and
> at the same time, deleting this version of the driver from the
> drivers/staging/hv/ directory?

Well, yes, it has the same build failure as the previous one and that
will make it non bisectable.

James


