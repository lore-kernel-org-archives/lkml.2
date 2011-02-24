Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1BXOzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:55:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64465 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1BXOzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:55:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pBzHQFALpAd8jZg9ejGk3dxji5bAKJIfvUKXu+yvbsr5zOWQW3hLbpATCGDF0VqjJC
         X59jU3YYTLVSqLvaFYsqH3+O37/apS/FIP2zbeq3OU9mr2v3cym0OHnZIfTzjuACEwIR
         MbUT/vAF/GFtohd3iuAaVJ4WMxl+nuEZrXw20=
Date: Thu, 24 Feb 2011 15:55:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix refcounting in swapon
Message-ID: <20110224145503.GP7840@htj.dyndns.org>
References: <E1PscVt-0004ad-W9@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PscVt-0004ad-W9@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 03:49:53PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Grab a reference to bdev before calling blkdev_get(), which expects
> the refcount to be already incremented and either returns success or
> decrements the refcount and returns an error.
> 
> The bug was introduced by e525fd89 (block: make blkdev_get/put()
> handle exclusive access), which didn't take into account this behavior
> of blkdev_get().
> 
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
