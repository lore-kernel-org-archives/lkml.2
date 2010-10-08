Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0JHHff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:35:35 -0400
Received: from canuck.infradead.org ([134.117.69.58]:56587 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0JHHfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:35:34 -0400
Date: Fri, 8 Oct 2010 03:35:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/18] fs: add a per-superblock lock for the inode list
Message-ID: <20101008073533.GA24089@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-13-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:26PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To allow removal of the inode_lock, we first need to protect the
> superblock inode list with its own lock instead of using the
> inode_lock. Add a lock to the superblock to protect this list and
> nest the new lock inside the inode_lock around the list operations
> it needs to protect.
> 
> Based on a patch originally from Nick Piggin.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
