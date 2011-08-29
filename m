Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1H2V2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:28:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab1H2V2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:28:02 -0400
Date: Mon, 29 Aug 2011 14:27:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 8/9] um: fix strrchr problems
Message-Id: <20110829142705.5be82d7c.akpm@linux-foundation.org>
In-Reply-To: <1314634419-24766-9-git-send-email-richard@nod.at>
References: <1314634419-24766-1-git-send-email-richard@nod.at>
	<1314634419-24766-9-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 8/9] um: fix strrchr problems

What are the problems?

On Mon, 29 Aug 2011 18:13:38 +0200
Richard Weinberger <richard@nod.at> wrote:

> From: Al Viro <viro@ftp.linux.org.uk>
> 
> Several years old patch, originally by jdike, I think...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/um/Makefile b/arch/um/Makefile
> index fab8121..c0f712c 100644
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -41,7 +41,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
>  KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
>  	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
>  	-Din6addr_loopback=kernel_in6addr_loopback \
> -	-Din6addr_any=kernel_in6addr_any
> +	-Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr
>  
>  KBUILD_AFLAGS += $(ARCH_INCLUDE)

z:/usr/src/linux-3.1-rc4> grep -r kernel_strrchr .       
z:/usr/src/linux-3.1-rc4> 

ok, I give up.  How does this work?
