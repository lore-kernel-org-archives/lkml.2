Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab0GTPag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:30:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:34543 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab0GTPaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:30:35 -0400
Date: Tue, 20 Jul 2010 17:30:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Boyd <bebarino@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fs/Kconfig: Fix typo Userpace -> Userspace
In-Reply-To: <1279298804-4496-1-git-send-email-bebarino@gmail.com>
Message-ID: <alpine.LNX.2.00.1007201730230.4741@pobox.suse.cz>
References: <1279298804-4496-1-git-send-email-bebarino@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010, Stephen Boyd wrote:

> Signed-off-by: Stephen Boyd <bebarino@gmail.com>
> ---
> 
> Ah sorrry, missing subject.
> 
>  fs/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 5f85b59..3d18530 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -64,7 +64,7 @@ source "fs/autofs4/Kconfig"
>  source "fs/fuse/Kconfig"
>  
>  config CUSE
> -	tristate "Character device in Userpace support"
> +	tristate "Character device in Userspace support"
>  	depends on FUSE_FS
>  	help
>  	  This FUSE extension allows character devices to be

Applied, thanks Stephen.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
