Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab0JMN1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:27:39 -0400
Received: from canuck.infradead.org ([134.117.69.58]:57100 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0JMN1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:27:38 -0400
Date: Wed, 13 Oct 2010 09:27:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/18] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101013132737.GB5263@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-13-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:15:55AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently protect the per-inode state flags with the inode_lock.
> Using a global lock to protect per-object state is overkill when we
> coul duse a per-inode lock to protect the state.  Use the
> inode->i_lock for this, and wrap all the state changes and checks
> with the inode->i_lock.
> 
> Based on work originally written by Nick Piggin.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

