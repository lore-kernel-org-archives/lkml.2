Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2FWDuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 23:50:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32796 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2FWDuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 23:50:16 -0400
Date: Fri, 22 Jun 2012 20:50:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Lawrence <daniel@danielscottlawrence.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fixed printk coding style issue in
 acl7225b.c
Message-ID: <20120623035012.GA27972@kroah.com>
References: <1340419903-21928-1-git-send-email-daniel@danielscottlawrence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340419903-21928-1-git-send-email-daniel@danielscottlawrence.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 12:51:43PM +1000, Daniel Lawrence wrote:
> This is a patch to the acl7225.b file that fixes up 2 printk warnings
> found by the checkpatch.pl tool.
> As this is a comedi driver the printk's have been changed to the
> dev_printk style.
> 
> Signed-off-by: Daniel Lawrence <daniel@danielscottlawrence.com>
> ---
>  drivers/staging/comedi/drivers/acl7225b.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This patch does not apply properly, what tree did you make it against?
Can you please redo it against the latest linux-next tree and resend it
so that I can apply it?

thanks,

greg k-h
