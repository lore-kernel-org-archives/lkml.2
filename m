Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2JVSks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:40:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:57974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2JVSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:40:46 -0400
Message-ID: <5085932D.4000108@kernel.dk>
Date: Mon, 22 Oct 2012 20:40:45 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Anna Leuschner <anna.m.leuschner@gmail.com>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix: don't increase bio_slab_max if krealloc() fails
References: <1350851609-10541-1-git-send-email-anna.m.leuschner@gmail.com>
In-Reply-To: <1350851609-10541-1-git-send-email-anna.m.leuschner@gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-21 22:33, Anna Leuschner wrote:
> bio.c: fix: don't increase bio_slab_max if krealloc() of bio_slabs fails

You failed the "how to write a commit message" part of the patch :-)
The commit message should talk about WHY a change is necessary, not
HOW it is done. The latter should be obvious from looking at the code
change.

So, in other words, please describe why the change is useful or needed.
Then resend.

-- 
Jens Axboe

