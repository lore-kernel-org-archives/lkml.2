Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1CPNSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:18:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab1CPNSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:18:02 -0400
Date: Wed, 16 Mar 2011 09:18:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@MIT.EDU>,
        Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110316131800.GA12175@infradead.org>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
 <20110316061917.GA30195@dastard>
 <20110316065103.GP22723@ZenIV.linux.org.uk>
 <20110316072123.GR22723@ZenIV.linux.org.uk>
 <B0CB85F7-23A7-45EA-848E-8B2701545371@mit.edu>
 <20110316130728.GB30866@infradead.org>
 <20110316131502.GS22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316131502.GS22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 01:15:02PM +0000, Al Viro wrote:
> Yes.  See patch upthread (or in for-linus).  There are two parts in that
> test; *both* would actually trigger the b0rkage in the last commit of
> what got merged - the only reason why the first one (long chain) did not
> was that the limit got fixed and -ELOOP was no longer triggered.  Symlink
> to itself did, of course, trigger it - complete with oops.

Yes.  I have a patch to increase the limit tested in 005 and it now
passes fine.

