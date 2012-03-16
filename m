Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab2CPUgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:36:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59785 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab2CPUgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:36:47 -0400
Date: Fri, 16 Mar 2012 13:36:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] Drivers: scsi: storvsc: Set the scsi result
 correctly when SRB status is INVALID
Message-ID: <20120316203642.GA14802@kroah.com>
References: <1331929448-6838-1-git-send-email-kys@microsoft.com>
 <1331929472-6877-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331929472-6877-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 01:24:31PM -0700, K. Y. Srinivasan wrote:
> Currently Windows hosts only support a subset of scsi commands and for commands
> that are not supported, the host returns a generic SRB failure status.
> However, they have agreed to change the return value to indicate that
> the command is not supported. In preparation for that, handle the 
> SRB_STATUS_INVALID_REQUEST return value correctly.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |    8 ++++++++

I need an ack from the scsi maintainer before I can accept this patch.

James?

