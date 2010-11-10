Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab0KJQ2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:28:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab0KJQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:28:01 -0500
Date: Wed, 10 Nov 2010 11:27:54 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/6] fs: dcache documentation cleanup
Message-ID: <20101110162754.GA15130@infradead.org>
References: <20101109124610.GB11477@amd>
 <20101109125854.GD11477@amd>
 <20101109162415.GA6217@infradead.org>
 <20101109220600.GF3246@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109220600.GF3246@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 09:06:00AM +1100, Nick Piggin wrote:
> On Tue, Nov 09, 2010 at 11:24:15AM -0500, Christoph Hellwig wrote:
> > The patch looks good and I'm fine with sending it off to Linus ASAP.
> > But the commit message should not contain misc blurbs like the one
> > below.
> 
> It's not part of the changelog.

It is when applying your series using git-am, that's the only reason I
noticed anyway.

