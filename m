Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab1EDQMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:12:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1EDQMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:12:14 -0400
Date: Wed, 4 May 2011 08:11:49 -0700
From: Greg KH <gregkh@suse.de>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5]KernelDoc:Add the device driver-model structures to
 kerneldoc
Message-ID: <20110504151149.GB13302@suse.de>
References: <1304507741-3075-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304507741-3075-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 07:15:41PM +0800, Wanlong Gao wrote:
> 
> Hi Greg:
> 
> Sorry for adding your signed-off. But because that I thought I had got some thing
> from your articles and book in this patch.

That's fine, and you should say that in the patch description.  Please
re-read Documentation/SubmittingPatches for exactly what
"Signed-off-by:" means and you will see that you can not add other names
to a patch without their permission.

> 
> Hi Randy:
> Thanks very much for your careful checking this patch, and sorry for the errors,
> I'll be more carefully next time.
> And don't forget the other patch which removed these structures from the
> Documentation/driver-model/ .

Can you resend that, along with this one (with better description based
on above) again so that I can apply both of them at the same time?

thanks,

greg k-h
