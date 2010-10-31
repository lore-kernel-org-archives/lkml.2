Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0JaDFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 23:05:11 -0400
Received: from fieldses.org ([174.143.236.118]:47235 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab0JaDFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 23:05:08 -0400
Date: Sat, 30 Oct 2010 23:05:04 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: nfsd changes for 2.6.37
Message-ID: <20101031030504.GC24174@fieldses.org>
References: <20101026164549.GD19445@fieldses.org>
 <20101027083924.GA28129@infradead.org>
 <20101027133924.GB6328@fieldses.org>
 <201010271546.09036.arnd@arndb.de>
 <20101027145538.GC6328@fieldses.org>
 <20101027145929.GA5788@infradead.org>
 <20101030212500.GE480@fieldses.org>
 <20101031020707.GB29702@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101031020707.GB29702@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 10:07:08PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 30, 2010 at 05:25:00PM -0400, J. Bruce Fields wrote:
> > We still need to do this part.  I just did the minimum required to fix
> > the problem--I figure splitting out a separate ->delete_lease method
> > (which I agree would be cleaner) could wait till the next merge window.
> 
> I'd say please do it now.  The pre-allocated file_lock changes make
> the semantics inside ->setlease really nasty right now.  I think it's a
> dumb idea to leave it that way even for a single merge window.

OK, will do.

--b.
