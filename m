Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1IVQzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:55:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57134 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1IVQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:55:44 -0400
Date: Thu, 22 Sep 2011 09:56:05 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>
Subject: Re: linux-next: manual merge of the akpm with the block tree
Message-Id: <20110922095605.19c5227c.akpm00@gmail.com>
In-Reply-To: <20110922133717.GA21575@infradead.org>
References: <20110922182625.4a18ee494a0f3bf977fc8ea3@canb.auug.org.au>
	<20110922133717.GA21575@infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011 09:37:17 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 22, 2011 at 06:26:25PM +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > Today's linux-next merge of the scsi-post-merge tree got a conflict in
> > drivers/block/brd.c between commit 5a7bbad27a41 ("block: remove support
> > for bio remapping from ->make_request") from the block tree and commit
> > 4559c71773c5 ("brd_make_request() always returns 0, which doesn't make
> > much sense") from the akpm tree.
> 
> Where did the latter patch come from?  Given that brd_make_request is
> for the ramdisk driver that never does remapping returning anything but
> zero would be a bug anyway.

Yes, drivers-block-brdc-make-brd_make_request-return-error-code.patch
should be (has been) dropped.
