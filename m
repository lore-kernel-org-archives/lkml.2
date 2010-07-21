Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152Ab0GUF5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:57:11 -0400
Received: from ozlabs.org ([203.10.76.45]:52980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab0GUF5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 01:57:09 -0400
From: Michael Neuling <mikey@neuling.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
cc: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 92/92]Documentation/powerpc/booting-without-of.txt update web address.
In-reply-to: <1279688215-29628-2-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com> <1279688215-29628-2-git-send-email-justinmattock@gmail.com>
Comments: In-reply-to "Justin P. Mattock" <justinmattock@gmail.com>
   message dated "Tue, 20 Jul 2010 21:56:42 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 21 Jul 2010 15:57:06 +1000
Message-ID: <26080.1279691826@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <1279688215-29628-2-git-send-email-justinmattock@gmail.com> you wrot
e:
> The patch below fixes a broken web address.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  Documentation/powerpc/booting-without-of.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/pow
erpc/booting-without-of.txt
> index 46d2210..7882a10 100644
> --- a/Documentation/powerpc/booting-without-of.txt
> +++ b/Documentation/powerpc/booting-without-of.txt
> @@ -1048,7 +1048,7 @@ IV - "dtc", the device tree compiler
>  
>  
>  dtc source code can be found at
> -<http://ozlabs.org/~dgibson/dtc/dtc.tar.gz>
> +<http://ozlabs.org/>

I think this link should really be:
git clone git://www.jdl.com/software/dtc.git/

Mikey

>  
>  WARNING: This version is still in early development stage; the
>  resulting device-tree "blobs" have not yet been validated with the
> -- 
> 1.7.1.rc1.21.gf3bd6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
