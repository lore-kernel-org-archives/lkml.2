Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab0DWPwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:52:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23464 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab0DWPwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:52:31 -0400
Date: Fri, 23 Apr 2010 08:50:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chihau Chau <chihau@gmail.com>
Cc: jmorris@namei.org, eparis@redhat.com, viro@zeniv.linux.org.uk,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security: inode: Fix code style issues
Message-Id: <20100423085021.b54f98c5.randy.dunlap@oracle.com>
In-Reply-To: <1271983035-26401-1-git-send-email-chihau@gmail.com>
References: <1271983035-26401-1-git-send-email-chihau@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4BD1C22F.0211:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 20:37:15 -0400 Chihau Chau wrote:

> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes two code style issues:
> 
> - A space required after that close brace '}'

Why?  do we say that somewhere?


> 
> - A space required after that ','
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  security/inode.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/inode.c b/security/inode.c
> index c3a7938..f875f47 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -124,7 +124,7 @@ static inline int positive(struct dentry *dentry)
>  
>  static int fill_super(struct super_block *sb, void *data, int silent)
>  {
> -	static struct tree_descr files[] = {{""}};
> +	static struct tree_descr files[] = { {""} };
>  
>  	return simple_fill_super(sb, SECURITYFS_MAGIC, files);
>  }
> @@ -208,7 +208,7 @@ struct dentry *securityfs_create_file(const char *name, mode_t mode,
>  	struct dentry *dentry = NULL;
>  	int error;
>  
> -	pr_debug("securityfs: creating file '%s'\n",name);
> +	pr_debug("securityfs: creating file '%s'\n", name);
>  
>  	error = simple_pin_fs(&fs_type, &mount, &mount_count);
>  	if (error) {
> -- 
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
