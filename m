Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1IQDWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 23:22:31 -0400
Received: from ozlabs.org ([203.10.76.45]:54789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab1IQDWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 23:22:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: use blk_rq_map_kern
In-Reply-To: <20110915155051.GA29694@infradead.org>
References: <20110915155051.GA29694@infradead.org>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Fri, 16 Sep 2011 15:56:38 +0930
Message-ID: <87mxe59f4x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 11:50:52 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> Use blk_rq_map_kern instead of opencoding it for the serial sysfs attribute.
> 
> [Rusty, any chance to get this in through the block tree? I have some
>  other bits in that area pending for it]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sure, and I have nothing pending that conflicts.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
