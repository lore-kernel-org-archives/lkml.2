Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab0KDTvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:51:33 -0400
Received: from xenotime.net ([72.52.115.56]:53618 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752646Ab0KDTvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:51:32 -0400
Date: Thu, 4 Nov 2010 12:51:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: api.c: add comments to crypto_alg_lookup
 and crypto_alg_larval_lookup
Message-Id: <20101104125125.ed177cf4.rdunlap@xenotime.net>
In-Reply-To: <1288900188-19034-1-git-send-email-mark.a.allyn@intel.com>
References: <1288900188-19034-1-git-send-email-mark.a.allyn@intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Nov 2010 12:49:48 -0700 Mark Allyn wrote:

> This is resubmitted due to errors in style
> 
> Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
> ---
>  crypto/api.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 033a714..0314083 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -193,6 +193,13 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
>  	return alg;
>  }
>  
> +/**
> + * crypto_alg_lookup() - return crypto_alg structure for an algorithm
> + * @name:	text string containing name of algorithm
> + * @type:	crypto type defined in include/linux/crypto.h
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined in include/linux/crypto.h)
> + */
>  struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> @@ -205,6 +212,14 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  }
>  EXPORT_SYMBOL_GPL(crypto_alg_lookup);
>  
> +/**
> + * crypto_alg_larval_lookup() - returns large value (larval) crypto_alg
> + *	structure for an algorithm

That function name still does not match the actual name below.


> + * @name:	text string containing name of algorithm
> + * @type:	crypto type defined in include/linux/crypto.h
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined in include/linux/crypto.h)
> + */
>  struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
