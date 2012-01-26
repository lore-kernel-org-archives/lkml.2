Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2AZRiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:38:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab2AZRiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:38:01 -0500
Date: Thu, 26 Jan 2012 09:37:51 -0800
From: Greg KH <gregkh@suse.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the
 staging queue
Message-ID: <20120126173751.GA14400@suse.de>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
 <1327599515-12679-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327599515-12679-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 09:38:34AM -0800, K. Y. Srinivasan wrote:
> This patch gets the storage driver to the same level as in the staging tree.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/staging/hv/storvsc_drv.c | 1301 ++++++++++++++++++-------------------
>  1 files changed, 633 insertions(+), 668 deletions(-)

What?  That changelog comment makes no sense at all, as you are patching
the staging version of the driver.  This isn't an acceptable patch at
all.

Yes, I have pending patches for this driver in my "to-apply" queue, but
that is for 3.4, not now.

So, how about I just apply those patches, and then apply a patch that
moves it out of staging into drivers/scsi/, and queue all of those up
for 3.4.

James, any objection to that?

thanks,

greg k-h
