Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1IJGMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 02:12:25 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51577 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592Ab1IJGMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 02:12:24 -0400
X-Sasl-enc: 4q01kDBikzUIgk9ckbMSzWOjeLw23fRn5z7LopLJ3l9J 1315635143
Subject: Re: [PATCH] autofs4/root.c: quiet sparse noise
From: Ian Kent <raven@themaw.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
In-Reply-To: <201109091717.02975.hartleys@visionengravers.com>
References: <201109091717.02975.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Sep 2011 14:12:18 +0800
Message-ID: <1315635138.3171.1.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 17:17 -0700, H Hartley Sweeten wrote:
> The function autofs4_d_manage is prototyped as a static function.
> Add static to the function to quiet the sparse noise:
> 
> warning: symbol 'autofs4_d_manage' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Kent <raven@themaw.net>

Thought I had done that in the original series ....
Acked-by: Ian Kent <raven@themaw.net>

> 
> ---
> 
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index f55ae23..366a9f2 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -427,7 +427,7 @@ done:
>  	return NULL;
>  }
>  
> -int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
> +static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
>  {
>  	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
>  


