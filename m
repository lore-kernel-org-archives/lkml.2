Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1GEQPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:15:50 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33791 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348Ab1GEQPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:15:06 -0400
X-Sasl-enc: zkViRWBQ9eiHRA7oip/SVivekzxJobLBD1ri4mSJERq+ 1309882505
Date: Tue, 5 Jul 2011 09:11:57 -0700
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 1/5] staging: hv: fix some white spaces in netvsc driver
Message-ID: <20110705161157.GA24753@kroah.com>
References: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 07:58:04AM -0700, Haiyang Zhang wrote:
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/staging/hv/netvsc.c     |    8 ++++----
>  drivers/staging/hv/netvsc_drv.c |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)

This is the only patch in the series that would apply (well, I didn't
try the 5/5 patch for the reasons stated there.)

Please redo these against the latest staging-next branch if you want
them applied.

thanks,

greg k-h
