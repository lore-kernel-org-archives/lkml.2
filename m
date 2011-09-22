Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1IVNhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:37:23 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54128
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543Ab1IVNhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:37:21 -0400
Date: Thu, 22 Sep 2011 09:37:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Eric Miao <eric.miao@linaro.org>
Subject: Re: linux-next: manual merge of the akpm with the block tree
Message-ID: <20110922133717.GA21575@infradead.org>
References: <20110922182625.4a18ee494a0f3bf977fc8ea3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922182625.4a18ee494a0f3bf977fc8ea3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 06:26:25PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the scsi-post-merge tree got a conflict in
> drivers/block/brd.c between commit 5a7bbad27a41 ("block: remove support
> for bio remapping from ->make_request") from the block tree and commit
> 4559c71773c5 ("brd_make_request() always returns 0, which doesn't make
> much sense") from the akpm tree.

Where did the latter patch come from?  Given that brd_make_request is
for the ramdisk driver that never does remapping returning anything but
zero would be a bug anyway.

