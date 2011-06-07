Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab1FGXFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:05:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1FGXFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:05:48 -0400
Date: Tue, 7 Jun 2011 16:04:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/15] writeback fixes and cleanups for 3.0 (v5)
Message-Id: <20110607160441.db475211.akpm@linux-foundation.org>
In-Reply-To: <20110607213236.634026193@intel.com>
References: <20110607213236.634026193@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011 05:32:36 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> 
> Andrew,
> 
> Here are the intented patches for upstream submission, rebased to v3.0-rc2:
> 
> 	[PATCH 01/15] writeback: introduce .tagged_writepages for the WB_SYNC_NONE sync stage
> 	[PATCH 02/15] writeback: update dirtied_when for synced inode to prevent livelock
> 	[PATCH 03/15] writeback: introduce writeback_control.inodes_cleaned
> 	[PATCH 04/15] writeback: try more writeback as long as something was written
> 	[PATCH 05/15] writeback: the kupdate expire timestamp should be a moving target
> 	[PATCH 06/15] writeback: refill b_io iff empty
> 	[PATCH 07/15] writeback: split inode_wb_list_lock into bdi_writeback.list_lock
> 	[PATCH 08/15] writeback: elevate queue_io() into wb_writeback()
> 	[PATCH 09/15] writeback: avoid extra sync work at enqueue time
> 	[PATCH 10/15] writeback: add bdi_dirty_limit() kernel-doc
> 	[PATCH 11/15] writeback: skip balance_dirty_pages() for in-memory fs
> 	[PATCH 12/15] writeback: remove writeback_control.more_io
> 	[PATCH 13/15] writeback: remove .nonblocking and .encountered_congestion
> 	[PATCH 14/15] writeback: trace event writeback_single_inode
> 	[PATCH 15/15] writeback: trace event writeback_queue_io

Looks OK to me, although I think a few of the changelogs are lacking
important details.

> They are git pullable from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback
> 

Please ask Stephen to suck this into linux-next when ready.
