Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab1DYRqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:46:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695Ab1DYRqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:46:14 -0400
Date: Mon, 25 Apr 2011 13:46:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/4] fs: Convert inode slab creation to use consistent
 parameters
Message-ID: <20110425174608.GA9779@infradead.org>
References: <1289201305-14866-1-git-send-email-david@fromorbit.com>
 <1289201305-14866-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289201305-14866-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 06:28:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode slab creation functions in different filesystem don't all set up the
> slab caches correctly. Add a new flag SLAB_INODES that sets all the necessary
> flags for an inode slab cache and convert all the callers to use it. THis makes
> it easy to change the behaviour of all the inode slab caches in one go.

Any chance you could rediff this one ontop of current mainline and
resend it?

