Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2CDWZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 17:25:54 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49792 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2CDWZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 17:25:53 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2012 17:25:53 EST
Date: Sun, 4 Mar 2012 15:19:16 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, "Ted Ts'o" <tytso@mit.edu>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know
	of any filesystems that depend on the exact VFS 'namehash'
	implementation?)
Message-ID: <20120304221915.GA19570@parisc-linux.org>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org> <20120303000203.GH22215@thunk.org> <alpine.DEB.2.02.1203021616040.23477@asgard.lang.hm> <CA+55aFw7C3XYzwZ8F31EA4Svj1WZ8O--HV82qVg3t=JpxRy1Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw7C3XYzwZ8F31EA4Svj1WZ8O--HV82qVg3t=JpxRy1Ww@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 04:24:11PM -0800, Linus Torvalds wrote:
> Tons of CPU's have efficient char accesses but horrible unaligned word
> accesses. Some are even outright buggy (ie at least some ARM cores)
> and load crap. Others take a fault.

To be fair, that wasn't the ARM core.  That was the MEMC chip (roughly
equivalent to a northbridge).  Also, there's no need for Linux to care
about that any more, since we removed the arm26 port in July 2007.  As far
as I know, all arm32 cores have been coupled with memory controllers
that are functional.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
