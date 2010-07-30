Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0G3Kkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:40:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0G3Kkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:40:52 -0400
Date: Fri, 30 Jul 2010 06:40:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: move del_gendisk() from fs/partitions/check.c to
 block/genhd.c
Message-ID: <20100730104050.GA30499@infradead.org>
References: <1280482741.1851.3.camel@yio.site>
 <20100730094038.GA9570@infradead.org>
 <AANLkTik-htE1mbJbnGCNwsjVJyWF24nA9dNbsRNMzuia@mail.gmail.com>
 <20100730095854.GA26949@infradead.org>
 <AANLkTinUOgBPY=CYf-FGq1VcrUkR9+75vxXGYKsRQzqj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinUOgBPY=CYf-FGq1VcrUkR9+75vxXGYKsRQzqj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 12:04:09PM +0200, Kay Sievers wrote:
> Are you sure, that partition formats don't belong in fs/? It's kinda
> specific on-disk-layout like a fs, and I would have no problem with
> that staying in fs/.

It's on disk formats, but it's not related to filesystems at all.

