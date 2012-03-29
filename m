Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab2C2XvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:51:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60875 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab2C2XvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:51:16 -0400
Date: Thu, 29 Mar 2012 16:51:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Properly handle errors from
 the host
Message-ID: <20120329235111.GA19924@kroah.com>
References: <1333065283-30484-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
In-Reply-To: <1333065283-30484-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 04:54:43PM -0700, K. Y. Srinivasan wrote:
> If the host returns error for pass through commands, deal with
> appropriately. I would like to thank James for patiently helping
> me with this patch.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)

As this driver is now in Linus's tree, and drivers/scsi/ is James's
area, he is the one to take them, not me.

thanks,

greg k-h
