Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194Ab0HFXcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:32:15 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46954 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761200Ab0HFXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:32:13 -0400
Date: Sat, 7 Aug 2010 08:32:07 +0900
From: Simon Horman <horms@verge.net.au>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] MAINTAINERS: kexec-tools has moved
Message-ID: <20100806233203.GA10040@verge.net.au>
References: <20100729041641.GA32220@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729041641.GA32220@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 01:16:41PM +0900, Simon Horman wrote:
> Kexec tools has been moved to http://kernel.org/pub/linux/utils/kernel/kexec/
> as user-space code shouldn't be in /pub/linux/kernel
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>

Eric, ping.

What is your preferred path for this change to get merged?

> 
> Index: linux-2.6/MAINTAINERS
> ===================================================================
> --- linux-2.6.orig/MAINTAINERS	2010-07-29 13:10:04.000000000 +0900
> +++ linux-2.6/MAINTAINERS	2010-07-29 13:11:40.000000000 +0900
> @@ -3334,7 +3334,7 @@ F:	drivers/s390/kvm/
>  
>  KEXEC
>  M:	Eric Biederman <ebiederm@xmission.com>
> -W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
> +W:	http://kernel.org/pub/linux/utils/kernel/kexec/
>  L:	kexec@lists.infradead.org
>  S:	Maintained
>  F:	include/linux/kexec.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
