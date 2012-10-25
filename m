Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab2JYRE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202Ab2JYRE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:04:56 -0400
Date: Thu, 25 Oct 2012 15:04:52 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: xattr: rewrite simple_xattr_set()
Message-ID: <20121025170452.GA27092@andromeda.usersys.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20121025152613.GF14085@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025152613.GF14085@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:26:14AM -0400, Aristeu Rozanski wrote:
> The way this function was written is confusing and already caused problems.
> Rewriting it to be easier to understand and maintain.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  fs/xattr.c |  124 +++++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 76 insertions(+), 48 deletions(-)
> 
> Index: github/fs/xattr.c
> ===================================================================
> --- github.orig/fs/xattr.c	2012-10-23 16:02:41.155857391 -0400
> +++ github/fs/xattr.c	2012-10-25 11:17:15.118197552 -0400
> @@ -842,55 +842,46 @@
>  	return ret;
>  }
>  

Looks good to me

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
-- 
--Carlos
