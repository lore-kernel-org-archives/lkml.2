Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab1DVErn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 00:47:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab1DVErm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 00:47:42 -0400
Date: Fri, 22 Apr 2011 00:47:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Message-ID: <20110422044740.GA17795@infradead.org>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303414954-3315-1-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll also need:

 - a patch to lseek(2) to document the new flags
 - some testcases for xfstests, specially dealing with things that
   were problematic in FIEMAP, e.g. data in delalloc extents, making
   sure stuff in unwrittent extents partially converted actually gets
   copied, etc.
