Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab0HKBCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:02:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56395 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0HKBB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:01:58 -0400
Date: Wed, 11 Aug 2010 02:01:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Sripathi Kodi <sripathik@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: remove inode_setattr
Message-ID: <20100811010152.GD31363@ZenIV.linux.org.uk>
References: <201008101859.o7AIx9BM026915@hera.kernel.org>
 <20100810155011.b9657102.akpm@linux-foundation.org>
 <20100811101751.1afdded8.sfr@canb.auug.org.au>
 <20100811104503.4082f68f.sfr@canb.auug.org.au>
 <20100811005216.GB31363@ZenIV.linux.org.uk>
 <20100810175944.5919319e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810175944.5919319e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 05:59:44PM -0700, Andrew Morton wrote:

> That's v9fs_vfs_setattr().  The problem is in the new
> v9fs_vfs_setattr_dotl().

Yeah, see another posting...  Fix is in the queue I'm putting together
for tonight.  Sorry about that...
