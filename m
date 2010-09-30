Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab0I3CVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:21:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0I3CVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:21:40 -0400
Date: Wed, 29 Sep 2010 22:21:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/17] fs: Inode cache scalability
Message-ID: <20100930022140.GB21198@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, another relatively easy patch from Nick's series is:

	http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=commitdiff;h=950bbff18b19663abc2d260e352efd51fd79dbf7

although I think the second hunk could be done better by simply not
calling __inode_add_to_lists but just factoring out a hunk to add the
inode only to the i_sb_list which is all that's left after the patches
in this series.  And of course both hunks should be separate patches.
