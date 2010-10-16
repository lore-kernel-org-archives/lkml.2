Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0JPQOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:14:14 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33071 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0JPQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:14:12 -0400
Date: Sat, 16 Oct 2010 12:14:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] fs: Clean up inode reference counting
Message-ID: <20101016161411.GB16861@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-18-git-send-email-david@fromorbit.com>
 <20100930021520.GA21198@infradead.org>
 <20101016075515.GI19147@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016075515.GI19147@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 06:55:15PM +1100, Nick Piggin wrote:
> On Wed, Sep 29, 2010 at 10:15:20PM -0400, Christoph Hellwig wrote:
> > Besides moving this much earlier in the series as mentioned before
> > the most important thing is giving the helpers a different name as
> > the iget name is already used for a different purpose, even if
> > got rid of the original iget and only have iget_locked.
> 
> It's a bit of a mess. We also have __iget. I don't care much about
> the name though so I'll see what you've chosen in future posts.
> 
> I'll see how it looks to move earlier in the series, shouldn't
> be a big problem.

Dave has sorted out the naming mess quite nicely in his repost.
