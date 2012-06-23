Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2FWEDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:03:36 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58599 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790Ab2FWEDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:03:31 -0400
X-Sasl-enc: 6efxguPeuY80uGWn065FTUr+t8aN1K6P+Y8oZvHRYvTh 1340424210
Date: Fri, 22 Jun 2012 21:03:29 -0700
From: Greg KH <greg@kroah.com>
To: Sherwin Soltani <sherwin@wybc.com>
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: logger.c: fixed some printk macros
Message-ID: <20120623040329.GA14690@kroah.com>
References: <1340343886-311-1-git-send-email-sherwin@wybc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340343886-311-1-git-send-email-sherwin@wybc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 01:44:46AM -0400, Sherwin Soltani wrote:
> Changed a few printk messages in logger.c to make checkpatch.pl happy.
> 
> Signed-off-by: Sherwin Soltani <sherwin@wybc.com>
> ---
>  drivers/staging/android/logger.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

This patch does not apply, did you make it against Linus's tree or
linux-next?  You need to always work off of linux-next please.

thanks,

greg k-h
