Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2HVRn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:43:59 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58370 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2HVRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:43:56 -0400
Date: Wed, 22 Aug 2012 20:43:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 08/13] block: Add an explicit bio flag for bios that
 own their bvec
Message-ID: <20120822174351.GA27453@bunk.dyndns.info>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-9-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345655050-28199-9-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:04:05AM -0700, Kent Overstreet wrote:
>...
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -117,6 +117,7 @@ struct bio {
>   * BIO_POOL_IDX()
>   */
>  #define BIO_RESET_BITS	12
> +#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
>...

This doesn't look right.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

