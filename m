Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1IFTJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:09:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1IFTJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:09:48 -0400
Date: Tue, 6 Sep 2011 12:06:15 -0700
From: Greg KH <greg@kroah.com>
To: Mike Sterling <mike.sterling@microsoft.com>
Cc: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 1/1] staging: hv: Add support for >2 TB LUN in storage
 driver.
Message-ID: <20110906190615.GA31897@kroah.com>
References: <1314915069-1796-1-git-send-email-mike.sterling@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314915069-1796-1-git-send-email-mike.sterling@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 03:11:09PM -0700, Mike Sterling wrote:
> If a LUN larger than 2 TB is attached to a Linux VM on Hyper-V, we currently 
> report a maximum size of 2 TB. This patch resolves the issue in hv_storvsc. 
> Thanks to Robert Scheck <robert.scheck@etes.de> for reporting the issue.
> 
> Reported-by: Robert Scheck <robert.scheck@etes.de>
> Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
> Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/hyperv_storage.h |    1 +

This file is no longer in the latest kernel tree (linux-next or
staging-next).  What tree did you generate this patch against?  And
how come Haiyang and KY didn't catch such a basic mistake in their
review...

I'm guessing that this patch was not even tested :(

Please fix this and resend.

greg k-h
