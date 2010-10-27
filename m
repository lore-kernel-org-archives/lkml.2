Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0J0UYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:24:49 -0400
Received: from fieldses.org ([174.143.236.118]:50118 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab0J0UYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:24:47 -0400
Date: Wed, 27 Oct 2010 16:24:42 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: nfsd changes for 2.6.37
Message-ID: <20101027202442.GF18974@fieldses.org>
References: <20101026164549.GD19445@fieldses.org>
 <201010272148.47376.arnd@arndb.de>
 <20101027200145.GE18974@fieldses.org>
 <201010272220.20567.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010272220.20567.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 10:20:20PM +0200, Arnd Bergmann wrote:
> On Wednesday 27 October 2010 22:01:45 J. Bruce Fields wrote:
> > (You're missing Linus's comment fix, though, unless I'm confused.)
> 
> Right, I didn't look into the attachment, so I hadn't noticed
> the new changelog. I've updated the changelog to Linus' version,
> as it's more verbose than mine.

He fixed a code comment too, though.  No big deal.

> I also checked that the version in your tree is actually the
> right one, so I left the code untouched.

Yup, looks good.

--b.
