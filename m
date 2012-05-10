Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288Ab2EJVgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:36:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760267Ab2EJVgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:36:03 -0400
Date: Thu, 10 May 2012 17:35:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Subject: Re: [dm-devel] [Bcache v13 01/16] Only clone bio vecs that are in use
Message-ID: <20120510213556.GO23768@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:08:13PM -0400, Kent Overstreet wrote:

[..]
> -
> -	if (bio_integrity(bio)) {
> -		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
> -
> +#if 0
> +	if (bio_integrity(bio))
>  		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
>  			bio_integrity_trim(clone,
>  					   bio_sector_offset(bio, idx, 0), len);
> -	}
> -
> +#endif

Dead/debug code under "#if 0" ?

Thanks
Vivek
