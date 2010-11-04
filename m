Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab0KDRZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:25:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:2615 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab0KDRZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,296,1286175600"; 
   d="scan'208";a="344694101"
From: "Allyn, Mark A" <mark.a.allyn@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Date: Thu, 4 Nov 2010 11:25:06 -0600
Subject: RE: [PATCH 1/1] crypto: api.c adding kernel-doc comments
Thread-Topic: [PATCH 1/1] crypto: api.c adding kernel-doc comments
Thread-Index: Act8ROeUQeNeOJdNSdqyZKTpz5sxuwAADmlA
Message-ID: <8A0E4C92AE2D6D40AF99653191DA32316141394940@rrsmsx501.amr.corp.intel.com>
References: <1288890442-11208-1-git-send-email-mark.a.allyn@intel.com>
 <20101104102219.7ec24969.rdunlap@xenotime.net>
In-Reply-To: <20101104102219.7ec24969.rdunlap@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my first time in attempting to patch documentation. Shall I follow your suggestions by submitting a patch that depends on this patch or shall I submit the whole thing again with the corrections?

Mark

-----Original Message-----
From: Randy Dunlap [mailto:rdunlap@xenotime.net] 
Sent: Thursday, November 04, 2010 10:22 AM
To: Allyn, Mark A
Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: api.c adding kernel-doc comments

On Thu,  4 Nov 2010 10:07:22 -0700 Mark Allyn wrote:

> Add comments to crypto_alg_lookup and crypto_larval_lookup
> 
> I am re-submitting this due to errors
> 
> Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
> ---
>  crypto/api.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 033a714..71c389d 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -193,6 +193,15 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
>  	return alg;
>  }
>  
> +/**
> + * crypto_alg_lookup() return crypto_alg structure for an algorithm

needs hyphen between function name and "return".

> + * @name:	text string containing name of algorithm
> + * @type:	crypto type (defined at about line 31 of
> + *		include/linux/crypto.h)
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined at about line 31 of
> + *		include/linux/crypto.h)

drop the line numbers...

> + */
>  struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> @@ -205,6 +214,16 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  }
>  EXPORT_SYMBOL_GPL(crypto_alg_lookup);
>  
> +/**
> + * crypto_alg_larval lookup() return large value (larval) crypto_alg

 * crypto_larval_lookup() - return large value (larval) crypto_alg


> + *	structure for an algorithm
> + * @name:	text string containing name of algorithm
> + * @type:	crypto type (defined at about line 31 of
> + *		include/linux/crypto.h)
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined at about line 31 of
> + *		include/linux/crypto.h)
> + */

drop the line numbers.

>  struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
