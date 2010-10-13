Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0JMLbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:31:24 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47299 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab0JMLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:31:23 -0400
Date: Wed, 13 Oct 2010 07:31:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] fs: inode split IO and LRU lists
Message-ID: <20101013113122.GA19456@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:15:47AM +1100, Dave Chinner wrote:
> From: Nick Piggin <npiggin@suse.de>
> 
> The use of the same inode list structure (inode->i_list) for two
> different list constructs with different lifecycles and purposes
> makes it impossible to separate the locking of the different
> operations. Therefore, to enable the separation of the locking of
> the writeback and reclaim lists, split the inode->i_list into two
> separate lists dedicated to their specific tracking functions.

looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

