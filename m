Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0HTJVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:21:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0HTJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:21:40 -0400
Date: Fri, 20 Aug 2010 05:21:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Paris <eparis@redhat.com>, Andreas Gruenbacher <agruen@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] notification tree: directory events
Message-ID: <20100820092127.GC20138@infradead.org>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
 <201008191444.08966.agruen@suse.de>
 <1282230012.21419.1566.camel@acb20005.ipt.aol.com>
 <201008200141.10068.agruen@suse.de>
 <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
 <5FB2A21F-95D3-4B99-A521-74346EEEAF5B@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FB2A21F-95D3-4B99-A521-74346EEEAF5B@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 11:19:07PM -0600, Andreas Dilger wrote:
> What about unifying the file identification here with the file handle used for open_by_handle()?  That keeps a consistent identifier for the inode between multiple system calls (always a good thing), and allows the inode to be opened again via open_by_handle() if needed.

That's what the dmapi callouts that are intendeded to do just about the
same as fanotify always did.  I'm pretty sure I brought this up earlier
in the discussion.
