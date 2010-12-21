Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0LUXxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:53:17 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:33955 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191Ab0LUXxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:53:16 -0500
Date: Wed, 22 Dec 2010 10:53:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: XFS status update for November 2010
Message-ID: <20101221235301.GD4907@dastard>
References: <20101220180013.GA16283@infradead.org>
 <4D109047.8050300@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D109047.8050300@panasas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 01:32:23PM +0200, Boaz Harrosh wrote:
> On 12/20/2010 08:00 PM, Christoph Hellwig wrote:
> >>From looking at the kernel git commits November looked like a pretty
> > slow month with just two hand full fixes going into the release candidates
> > for Linux 2.6.37, and none at all going into the development tree.
> > But in this case git statistics didn't tell the whole story - there
> > was a lot of activity on patches for the next merge window on the list.
> > The focus in November was still at metadata scalability, with various
> > patchsets that improves parallel creates and unlinks again, and also
> > improves 8-way dbench throughput by 30%.  In addition to that there
> > were patches to improve preallocation for NFS servers, to simplify
> > the writeback code, and to remove the XFS-internal percpu counters
> > for free space for the generic kernel percpu counters, which just needed
> > a small improvement.
> > 
> > On the user space side we saw the release of xfsprogs 3.1.4, which
> > contains various accumulated bug fixes and Debian packaging updates.
> > The xfsdump tree saw a large update to speed up restore by using
> > mmap for an internal database and remove the limitation of ~ 214
> > million directory entries per dump file.  The xfstests test suite
> > saw three new testcases and various fixes, including support for the
> > hfsplus filesystem.
> 
> Hi Christoph, happy holidays
> 
> I love these reports you do, thank you
> 
> I have one small request, could you please post them to
> linux-fsdevel as well. linux-kernel@vger.kernel.org is so crowded
> I keep missing them.

Boaz, you can set up a modification watch on this page:

http://xfs.org/index.php/XFS_Status_Updates

as Christoph posts the updates there as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
