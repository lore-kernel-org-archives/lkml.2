Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0JAGC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:02:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0JAGC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:02:28 -0400
Date: Fri, 1 Oct 2010 02:02:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] fs: icache protect inode state
Message-ID: <20101001060227.GF32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-9-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:18:40PM +1000, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> Before removing the inode_lock, we need to protect the inode list
> operations with the inode->i_lock. This ensures that all inode state
> changes are serialised regardless of the fact that the lists they
> are moving around might be protected by different locks. Hence we
> can safely protect an inode in transit from one list to another
> without needing to hold all the list locks at the same time.

The subject does not seem to match the patch description and content.

