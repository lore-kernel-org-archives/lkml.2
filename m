Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0ETL2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 07:28:25 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47889 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab0ETL2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 07:28:23 -0400
Date: Thu, 20 May 2010 13:28:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] fuse: support splice() reading from fuse device
Message-ID: <20100520112821.GP25951@kernel.dk>
References: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OF3kc-00084X-Hi@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20 2010, Miklos Szeredi wrote:
> This continues zero copy I/O support on the fuse interface.  The first
> part of the patchset (splice write support on fuse device) was posted
> here:
> 
>   http://lkml.org/lkml/2010/4/28/215
> 
> With Jens' pipe growing patch and additional fuse patches it was
> possible to achieve a 20GBytes/s write throghput on my laptop in a
> "null" filesystem (no page cache, data goes to /dev/null).

Do you have some numbers on how that compares to the same test with the
default 16 page pipe size?

-- 
Jens Axboe

