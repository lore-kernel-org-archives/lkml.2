Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2IQJSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:18:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab2IQJS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:18:27 -0400
Subject: Re: [PATCH v2 05/26] block: Add bio_end()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org, neilb@suse.de
In-Reply-To: <1347322957-25260-6-git-send-email-koverstreet@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	 <1347322957-25260-6-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 17 Sep 2012 10:17:24 +0100
Message-ID: <1347873444.2688.3.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-09-10 at 17:22 -0700, Kent Overstreet wrote:
> Just a little convenience macro - main reason to add it now is preparing
> for immutable bio vecs, it'll reduce the size of the patch that puts
> bi_sector/bi_size/bi_idx into a struct bvec_iter.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>

GFS2 bits:
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.


