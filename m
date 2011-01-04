Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1ADJZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:25:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1ADJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:25:42 -0500
Date: Tue, 4 Jan 2011 04:25:41 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110104092541.GC2760@infradead.org>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104083132.GA4485@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104083132.GA4485@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 07:31:32PM +1100, Nick Piggin wrote:
> And actually I think it is much better to have sync_inode, which means
> we'll be able to get rid of commit_metadata (which should be an inode
> operation anyway, not an export operation which really should deal with
> exporting filesystems to a non-vfs namespace, not nfsd hacks).
> 
> commit_metadata would just be sync_inode with a null range or no data
> sync flag set.

As explained in the previous mail it's not just not writing data, it's
conceptually quite different from fsync.

