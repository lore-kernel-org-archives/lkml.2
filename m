Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab0G2FBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:01:01 -0400
Received: from ozlabs.org ([203.10.76.45]:41504 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0G2FA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:00:58 -0400
From: Michael Neuling <mikey@neuling.org>
To: Simon Horman <horms@verge.net.au>
cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biederman <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] MAINTAINERS: kexec-tools has moved
In-reply-to: <20100729041641.GA32220@verge.net.au>
References: <20100729041641.GA32220@verge.net.au>
Comments: In-reply-to Simon Horman <horms@verge.net.au>
   message dated "Thu, 29 Jul 2010 13:16:41 +0900."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 29 Jul 2010 15:00:56 +1000
Message-ID: <24707.1280379656@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <20100729041641.GA32220@verge.net.au> you wrote:
> Kexec tools has been moved to http://kernel.org/pub/linux/utils/kernel/kexec/
> as user-space code shouldn't be in /pub/linux/kernel
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Index: linux-2.6/MAINTAINERS
> ===================================================================
> --- linux-2.6.orig/MAINTAINERS	2010-07-29 13:10:04.000000000 +0900
> +++ linux-2.6/MAINTAINERS	2010-07-29 13:11:40.000000000 +0900
> @@ -3334,7 +3334,7 @@ F:	drivers/s390/kvm/
>  
>  KEXEC
>  M:	Eric Biederman <ebiederm@xmission.com>

I think it's time to change or at least add you as a maintainer, Simon
:-)

Mikey

> -W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
> +W:	http://kernel.org/pub/linux/utils/kernel/kexec/
>  L:	kexec@lists.infradead.org
>  S:	Maintained
>  F:	include/linux/kexec.h
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
