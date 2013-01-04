Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3ADJYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:24:07 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36228
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563Ab3ADJYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:24:03 -0500
Message-ID: <50E69F67.6050407@kernel.dk>
Date: Fri, 04 Jan 2013 10:22:47 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 00/32] AIO performance improvements/cleanups, v3
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-27 02:59, Kent Overstreet wrote:
> Last posting: http://article.gmane.org/gmane.linux.kernel.aio.general/3242
> 
> As before, changes should mostly be noted in the patch descriptions. 
> 
> Some random bits:
>  * flush_dcache_page() patch is new
>  * Rewrote the aio_read_evt() stuff again
>  * Fixed a few comments
>  * Included some more patches, notably the batch completion stuff
> 
> My git repo has Jens' aio/dio patches on top of this stuff. As of the
> latest version, I'm seeing a couple percent better throughput with the
> ring buffer, and I think Jens was seeing a couple percent better with
> his linked list approach - at this point I think the difference is
> noise, we're both testing with fairly crappy drivers.

I still see 10-15% better performance with my non-ring method, so it's a
bit faster than that. That's on the single device, driving that to the
maximum.


-- 
Jens Axboe

