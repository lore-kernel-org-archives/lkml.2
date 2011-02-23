Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1BWJnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:43:20 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:50151 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1BWJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=i+/ktAQCH2iv2gLjHd7DTP9EEZnUYNwhuhPw68KeOZoSnSKuAKC/ClfaXYqMtyAWlC
         eIlo9sA46LwsY08EfFDfkRflieizqzpNf2/P77x0o7KzLQfctmQG5DTV4/uEuV/LR5jZ
         PcKiRSUPfRai/dWvt1MfAqrVihrNDJW11jrOg=
Date: Wed, 23 Feb 2011 17:43:09 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/18] MAINTAINERS: Remove unnecessary
 linux-kernel@vger.kernel.org entries
Message-ID: <20110223094307.GB3090@gmail.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <cover.1298439175.git.joe@perches.com>
 <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:41:58PM -0800, Joe Perches wrote:
> CC'ing lkml is the default and doesn't need separate entries.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  MAINTAINERS |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fc5d548..1ecba76 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2792,7 +2792,6 @@ F:	include/linux/gigaset_dev.h
>  
>  GPIO SUBSYSTEM
>  M:	Grant Likely <grant.likely@secretlab.ca>
> -L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  T:	git git://git.secretlab.ca/git/linux-2.6.git
>  F:	Documentation/gpio/gpio.txt
> @@ -2815,7 +2814,6 @@ F:	drivers/platform/x86/hdaps.c
>  HWPOISON MEMORY FAILURE HANDLING
>  M:	Andi Kleen <andi@firstfloor.org>
>  L:	linux-mm@kvack.org
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
>  S:	Maintained
>  F:	mm/memory-failure.c
> @@ -4692,7 +4690,6 @@ F:	drivers/i2c/busses/i2c-pasemi.c
>  
>  PADATA PARALLEL EXECUTION MECHANISM
>  M:	Steffen Klassert <steffen.klassert@secunet.com>
> -L:	linux-kernel@vger.kernel.org
>  L:	linux-crypto@vger.kernel.org
>  S:	Maintained
>  F:	kernel/padata.c
> @@ -4842,7 +4839,6 @@ F:	include/crypto/pcrypt.h
>  PER-CPU MEMORY ALLOCATOR
>  M:	Tejun Heo <tj@kernel.org>
>  M:	Christoph Lameter <cl@linux-foundation.org>
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git
>  S:	Maintained
>  F:	include/linux/percpu*.h
> @@ -6893,7 +6889,6 @@ F:	sound/soc/codecs/wm*
>  
>  WORKQUEUE
>  M:	Tejun Heo <tj@kernel.org>
> -L:	linux-kernel@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
>  S:	Maintained
>  F:	include/linux/workqueue.h
> -- 
> 1.7.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
