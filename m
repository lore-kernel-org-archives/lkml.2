Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0KIQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:25:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0KIQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:25:58 -0500
Date: Tue, 9 Nov 2010 11:25:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 5/6] fs: d_compare change for rcu-walk
Message-ID: <20101109162555.GC6217@infradead.org>
References: <20101109124610.GB11477@amd>
 <20101109130235.GF11477@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109130235.GF11477@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 12:02:35AM +1100, Nick Piggin wrote:
> cifs and jfs contain the non-trivial changes, where they no longer
> overwrite dentry name in their d_compare(), but rather use the
> d_revalidate() method for ensuring case preservation in the presence
> of negative dentries, taken from fatfs.

Please split these out to separate patches, and make sure you get
a review and testing from the jfs and cifs maintainers.  I don't think
this is .37 material any more.

