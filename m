Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1HXVbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:31:25 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38258 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042Ab1HXVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:31:24 -0400
X-Sasl-enc: dDfHTVqpxIZFVDEI2SUbYQkWmTT8W2Chho2iCs72K9CJ 1314221483
Date: Wed, 24 Aug 2011 14:30:18 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Kernel config option for number of devices
Message-ID: <20110824213018.GE9707@kroah.com>
References: <1314149690-3177-1-git-send-email-ngupta@vflare.org>
 <1314149690-3177-2-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314149690-3177-2-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 08:34:47AM +0700, Nitin Gupta wrote:
> Allows configuring default number of zram devices
> as kernel config option. User can override this
> value using 'num_devices' module parameter.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  drivers/staging/zram/Kconfig    |    9 +++++++++
>  drivers/staging/zram/zram_drv.c |   13 ++++++++-----
>  2 files changed, 17 insertions(+), 5 deletions(-)

This patch fails to apply to my staging-next branch:

	patching file drivers/staging/zram/Kconfig
	patching file drivers/staging/zram/zram_drv.c
	Hunk #1 FAILED at 780.
	Hunk #2 FAILED at 794.
	2 out of 2 hunks FAILED -- saving rejects to file drivers/staging/zram/zram_drv.c.rej

Care to refresh all 4 patches here against that branch and resend them
to me so that I can apply them?

thanks,

greg k-h
