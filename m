Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab2JVT75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:59:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:58989 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab2JVT74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:59:56 -0400
Message-ID: <5085A59A.8060206@kernel.dk>
Date: Mon, 22 Oct 2012 21:59:22 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Anna Leuschner <anna.m.leuschner@gmail.com>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfs: fix: don't increase bio_slab_max if krealloc()
 fails
References: <1350935616-24797-1-git-send-email-anna.m.leuschner@gmail.com>
In-Reply-To: <1350935616-24797-1-git-send-email-anna.m.leuschner@gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-22 21:53, Anna Leuschner wrote:
> Without the patch, bio_slab_max, representing bio_slabs capacity, is
> increased before krealloc() of bio_slabs. If krealloc() fails,
> bio_slab_max is too high. Fix that by only updating bio_slab_max if
> krealloc() is successful.

That's a lot better, thanks!

-- 
Jens Axboe

