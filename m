Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab2BJSCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:02:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43021 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2BJSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:02:32 -0500
Date: Fri, 10 Feb 2012 10:02:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, jbottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
 the staging area
Message-ID: <20120210180212.GA605@kroah.com>
References: <1328825688-4337-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328825688-4337-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 02:14:48PM -0800, K. Y. Srinivasan wrote:
> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in the
> staging tree for a while and this patch moves it out of the staging area.
> 
> James was willing to apply this patch during the 3.3-rc phase and a decision
> was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> patches for 3.4. Now that Greg has applied all of the pending storvsc patches,
> I am sending this patch to move this driver out of staging. Based on James'
> recommendation, this patch gets rid of the unneeded files in the staging/hv
> directory.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/Kconfig                       |    7 +++++++
>  drivers/scsi/Makefile                      |    3 +++
>  drivers/{staging/hv => scsi}/storvsc_drv.c |    0
>  drivers/staging/Kconfig                    |    2 --
>  drivers/staging/Makefile                   |    1 -
>  drivers/staging/hv/Kconfig                 |    5 -----
>  drivers/staging/hv/Makefile                |    3 ---
>  drivers/staging/hv/TODO                    |    5 -----
>  8 files changed, 10 insertions(+), 16 deletions(-)
>  rename drivers/{staging/hv => scsi}/storvsc_drv.c (100%)
>  delete mode 100644 drivers/staging/hv/Kconfig
>  delete mode 100644 drivers/staging/hv/Makefile
>  delete mode 100644 drivers/staging/hv/TODO

James, can I add your Acked-by: for this patch?

thanks,

greg k-h
