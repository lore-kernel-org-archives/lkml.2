Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1IAWZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:25:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab1IAWZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:25:00 -0400
Date: Thu, 1 Sep 2011 15:22:06 -0700
From: Greg KH <gregkh@suse.de>
To: Mike Sterling <mike.sterling@microsoft.com>
Cc: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 1/1] staging: hv: Add support for >2 TB LUN in storage
 driver.
Message-ID: <20110901222206.GA18024@suse.de>
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

Much better, thanks.

Is this something that needs to go to older kernels (3.0, 2.6.32, etc.)
as well?

greg k-h
