Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0EYFnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:43:05 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:51705 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756156Ab0EYFnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:43:02 -0400
Date: Tue, 25 May 2010 15:42:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Dave Chinner <dchinner@redhat.com>,
       Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>,
       xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] xfs: convert more trace events to DEFINE_EVENT
Message-ID: <20100525054254.GG12087@dastard>
References: <4BFA3815.7070000@cn.fujitsu.com>
 <1274758614.22648.205.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274758614.22648.205.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 11:36:54PM -0400, Steven Rostedt wrote:
> On Mon, 2010-05-24 at 16:25 +0800, Li Zefan wrote:
> > Use DECLARE_EVENT_CLASS, and save ~15K:
> > 
> >    text    data     bss     dec     hex filename
> >  171949   43028      48  215025   347f1 fs/xfs/linux-2.6/xfs_trace.o.orig
> >  156521   43028      36  199585   30ba1 fs/xfs/linux-2.6/xfs_trace.o
> > 
> > No change in functionality.
> > 
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

I'll get this pushed through the XFS tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
