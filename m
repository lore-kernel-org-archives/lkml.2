Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0KAPbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:31:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab0KAPbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:31:41 -0400
Date: Mon, 1 Nov 2010 11:31:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] fs: Use RCU freeing of inodes via SLAB_DESTROY_BY_RCU
Message-ID: <20101101153137.GA28791@infradead.org>
References: <1288589624-15251-1-git-send-email-david@fromorbit.com>
 <1288589624-15251-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288589624-15251-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 04:33:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Change the inode caches to use RCU freed inodes via the SLAB_DESTROY_BY_RCU
> method. While touching the slab creation functions for the inode caches, fix
> all of the slabs to use consistent flags by defining SLAB_INODES to be the set
> of common inode cache flags

I think this should be done as a separate preparatory patch.

