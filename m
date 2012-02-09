Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab2BIUEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:04:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab2BIUEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:04:10 -0500
Date: Thu, 9 Feb 2012 12:04:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
 the staging area
Message-ID: <20120209200404.GA8816@kroah.com>
References: <1328817851-13435-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328817851-13435-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 12:04:11PM -0800, K. Y. Srinivasan wrote:
> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in the
> staging tree for a while and this patch moves it out of the staging area.
> As per Greg's recommendation, this patch makes no changes to the staging/hv
> directory. Once the driver moves out of staging, we will cleanup the
> staging/hv directory.
> 
> James was willing to apply this patch during the 3.3-rc phase and a decision
> was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> patches for 3.4. Now that Greg has applied all of the pending storvsc patches,
> I am re-sending this patch to move this driver out of staging.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/Kconfig       |    7 +
>  drivers/scsi/Makefile      |    3 +
>  drivers/scsi/storvsc_drv.c | 1548 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1558 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/storvsc_drv.c

James, any objection to me applying this to the staging-next tree, and
at the same time, deleting this version of the driver from the
drivers/staging/hv/ directory?

thanks,

greg k-h
