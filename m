Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab1IZI0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:26:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab1IZI0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:26:05 -0400
Subject: Re: [PATCH] gfs2/inode.c: local functions should be static
From: Steven Whitehouse <swhiteho@redhat.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com
In-Reply-To: <201109231551.32939.hartleys@visionengravers.com>
References: <201109231551.32939.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 26 Sep 2011 09:27:38 +0100
Message-ID: <1317025658.2744.0.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2011-09-23 at 15:51 -0700, H Hartley Sweeten wrote:
> Quiets the sparse noise:
> 
> warning: symbol 'gfs2_initxattrs' was not declared. Should it be static?
> 
Where did you find this function? It is not in the upstream gfs2 code...

Steve.

> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> 
> ---
> 
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index 5431de9..5f2b157 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -624,7 +624,7 @@ fail:
>  	return error;
>  }
>  
> -int gfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> +static int gfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>  		    void *fs_info)
>  {
>  	const struct xattr *xattr;


