Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab1JZMU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:20:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751Ab1JZMUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:20:55 -0400
Date: Wed, 26 Oct 2011 14:17:06 +0200
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] lib: devres: add convenience function to remap a resource
Message-ID: <20111026121706.GC23457@suse.de>
References: <1319548607-28427-1-git-send-email-w.sang@pengutronix.de>
 <20111025153538.GA13012@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025153538.GA13012@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 08:35:38AM -0700, Tejun Heo wrote:
> On Tue, Oct 25, 2011 at 03:16:47PM +0200, Wolfram Sang wrote:
> > Almost every platform_driver does the three steps get_resource,
> > request_mem_region, ioremap. This does not only lead to a lot of code
> > duplication, but also a huge number of similar error strings and
> > inconsistent error codes on failure. So, introduce a helper function
> > which simplifies remapping a resource and make it hard to do something
> > wrong and add documentation for it.
> > 
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Greg KH <gregkh@suse.de>
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> Greg, can you please take this one?

Ok, I'll queue it up after the 3.2 merge window is over, for the 3.3
release.

thanks,

greg k-h
