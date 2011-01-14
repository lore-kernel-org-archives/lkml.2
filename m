Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1ANX3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:29:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25292 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1ANX3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:29:32 -0500
MIME-Version: 1.0
Message-ID: <3e5fe0d0-53a9-49fd-8c12-2ee94062dd0f@default>
Date: Fri, 14 Jan 2011 15:28:32 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: RE: clearcache (Was: Re: [git pull] vfs pile 1)
References: <20110113053554.GQ19804@ZenIV.linux.org.uk>
 <20110113172557.c016ec51.sfr@canb.auug.org.au>
 <20110113085547.GA7414@infradead.org>
 <20110113214239.1b23b523.sfr@canb.auug.org.au20110113220039.GF31800@thunk.org>
 <7aa3a707-4713-41ca-b9f1-327485774722@default
 20110114223525.GA20593@thunk.org>
In-Reply-To: <20110114223525.GA20593@thunk.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As a result, I've spent most of my
> > free time over the last three months working on kztmem, which will
> > hopefully serve the purpose.
> 
> You'll have to forgive me, but I have absolutely no idea what kztmem
> is or what it does.  Is it just compressed tmem, and hence, something
> that is only of interest to people using Xen?  If so, it's not clear
> to me how it will help non-Xen people become interested in these
> patches.

Ah, sorry, processing too much email backlog and left out some context...

Kztmem is entirely in-kernel, no virtualization required (neither
Xen nor KVM).  I'll cc you when I post V1 soon but, yes, it is
compressed *in-kernel* tmem, a more flexible/dynamic replacement for
zcache and possibly also for zram as well, architected and designed
to more easily (than zcache/zram) exploit some other directions
I plan to take with tmem concepts, including (but not limited to)
page-addressable memory (http://marc.info/?l=linux-mm&m=127811271605009).
Kztmem is coded (at least for now) as a staging driver, but uses
exactly the proposed cleancache (and frontswap) patches.

Hope that helps!
Dan
