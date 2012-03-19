Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab2CSG6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:58:25 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52114
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893Ab2CSG6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:58:23 -0400
Date: Mon, 19 Mar 2012 02:58:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] writeback: Remove outdated comment
Message-ID: <20120319065821.GB11113@infradead.org>
References: <1331283748-12959-1-git-send-email-jack@suse.cz>
 <1331283748-12959-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331283748-12959-3-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 10:02:26AM +0100, Jan Kara wrote:
> The comment is hopelessly outdated and misplaced. We no longer have 'bdi'
> part of writeback work, the comment about blockdev super is outdated,
> comment about throttling as well. Information about list handling is in
> more detail at queue_io(). So just move the bit about older_than_this to
> close to move_expired_inodes() and remove the rest.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
