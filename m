Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab0KJBsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:48:41 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:36046 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129Ab0KJBsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:48:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAuG2Ux5LcZK/2dsb2JhbACiOnK8KYVKBI9l
Date: Wed, 10 Nov 2010 12:48:18 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 5/6] fs: d_compare change for rcu-walk
Message-ID: <20101110014818.GA4187@amd>
References: <20101109124610.GB11477@amd>
 <20101109130235.GF11477@amd>
 <20101109162555.GC6217@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109162555.GC6217@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:25:55AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 10, 2010 at 12:02:35AM +1100, Nick Piggin wrote:
> > cifs and jfs contain the non-trivial changes, where they no longer
> > overwrite dentry name in their d_compare(), but rather use the
> > d_revalidate() method for ensuring case preservation in the presence
> > of negative dentries, taken from fatfs.
> 
> Please split these out to separate patches, and make sure you get

Yeah, good suggestion.

> a review and testing from the jfs and cifs maintainers.  I don't think
> this is .37 material any more.

We'll see. It's pretty trivial to test really, and method reused
from fatfs.

