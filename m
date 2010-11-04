Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab0KDQxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:53:09 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12795 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0KDQxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:53:08 -0400
Message-ID: <4CD2E4F3.4000008@caviumnetworks.com>
Date: Thu, 04 Nov 2010 09:53:07 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Mark Allyn <mark.a.allyn@intel.com>
CC: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: api.c: adding doxygen comments to api
References: <1288888362-10599-1-git-send-email-mark.a.allyn@intel.com>
In-Reply-To: <1288888362-10599-1-git-send-email-mark.a.allyn@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2010 16:53:43.0902 (UTC) FILETIME=[D71E27E0:01CB7C40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 09:32 AM, Mark Allyn wrote:
> Subject: [PATCH 1/1] crypto: api.c: adding doxygen comments to api

Do we really use doxygen in the kernel?  Perhaps a subject line 
containing the string 'kernel-doc' would be more accurate.

Reading kernel-doc-nano-HOWTO.txt will show you the proper format.

> Signed-off-by: Mark A. Allyn<mark.a.allyn@intel.com>
> ---
>   crypto/api.c |   14 ++++++++++++++
>   1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/crypto/api.c b/crypto/api.c
> index 033a714..a11939f 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -193,6 +193,13 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
>   	return alg;
>   }
>
> +/**
> + * This gets the crypto_alg structure for an algorithm
> + * it return struct crypto_alg
> + * @name: name of the algorithm
> + * @type: crypto type (defined at about line 31 of include/linux/crypto.h)

Referencing kernel source file line numbers in documentation seems like 
an excellent way to have the documentation quickly be incorrect.


> + * @mask: mask of allowable crypto types
> + */
>   struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>   {
>   	struct crypto_alg *alg;
> @@ -205,6 +212,13 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>   }
>   EXPORT_SYMBOL_GPL(crypto_alg_lookup);
>
> +/**
> + * This gets the large value crypto_alg structure for an algorithm
> + * it return struct crypto_alg
> + * @name: name of the algorithm
> + * @type: crypto type (defined at about line 31 of include/linux/crypto.h)
> + * @mask: mask of allowable crypto types
> + */
>   struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
>   {
>   	struct crypto_alg *alg;

