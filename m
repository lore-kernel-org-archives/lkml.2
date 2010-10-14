Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0JNJZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:25:45 -0400
Received: from verein.lst.de ([213.95.11.210]:34687 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab0JNJZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:25:43 -0400
Date: Thu, 14 Oct 2010 11:25:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: xfs-masters@oss.sgi.com, lkml <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [xfs-masters] [PATCH -next] xfs: eliminate kconfig dependency warning
Message-ID: <20101014092503.GA28446@lst.de>
References: <20101013210142.9d524535.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013210142.9d524535.randy.dunlap@oracle.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:01:42PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig dependency warning to satisfy dependencies:
> 
> warning: (XFS_FS && BLOCK || NFSD && NETWORK_FILESYSTEMS && INET && FILE_LOCKING && BKL) selects EXPORTFS which has unmet direct dependencies (NETWORK_FILESYSTEMS)

I'm not entirely sure what this gibberish means, but I'm pretty sure it
does not make sense.

EXPORTFS is a small module that doesn't have any dependencie, and it's
needed by XFS for the by-handle operation, and by nfsd for the same
thing.  It has absolutely nothing to do with networking or network
filesystems (as in network filesystem clients).

