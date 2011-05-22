Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1EVUEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:04:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63819 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1EVUEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=erlyRSHGxrZffVoETk7aidWTV63AM85c9uoonDaQJ9gA8P2p32RCwYUXynYM8j+T7T
         ETum6Gq+ApZtj4z3TUanrQsrbK4MKwl5ectODa86FMhvj+ZyuV0dqIunLRb6Y05APp1G
         /kf6ZKeP8ehLue8pfDgGWBrESI/6/aRKmVB7E=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1306092879.16902.1.camel@monotop>
References: <1306092879.16902.1.camel@monotop>
Date: Sun, 22 May 2011 22:04:34 +0200
Message-ID: <BANLkTin6=3rpchVFHi9P=6Cp31uL=vMM0w@mail.gmail.com>
Subject: Re: [PATCH] fs: add missing prefetch header to inode.c
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Eduardo Silva <edsiper@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 9:34 PM, Eduardo Silva <edsiper@gmail.com> wrote:
> inode.c fails in the compilation process due to the missing
> include of linux/prefetch.h.
>
> Signed-off-by: Eduardo Silva <edsiper@gmail.com>
> ---
>  fs/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index 33c963d..c77081f 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -26,6 +26,7 @@
>  #include <linux/posix_acl.h>
>  #include <linux/ima.h>
>  #include <linux/cred.h>
> +#include <linux/prefetch.h>
>  #include "internal.h"
>
>  /*
> --
> 1.7.4.1
>

Just FYI:
"fs: add missing prefetch.h include" is in Linus tree [1].

- Sedat -

[1] http://git.us.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9ce6e0be0626a5de2aca8b769a4aa57086257156
