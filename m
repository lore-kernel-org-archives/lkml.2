Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2LMWLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:11:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2LMWLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:11:06 -0500
Date: Thu, 13 Dec 2012 17:10:57 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS corruption on post 3.7 tree.
Message-ID: <20121213221057.GA22049@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
	xfs@oss.sgi.com
References: <20121213205522.GA28455@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213205522.GA28455@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 03:55:22PM -0500, Dave Jones wrote:
 > Doing a kernel build while running on a 3.7+ tree from last night and I hit this...
 > 
 > 
 > [22637.787422] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 163 of file fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa070086a

I unmounted, remounted, unmounted, and then ran xfs_repair on it, as prompted.
xfs_repair noted..

bad hash table for directory inode 201328949 (bad stale count): rebuilding

After remounting, things seemed ok again.
I blew away my .ccache on that drive, and restarted my compile,
and then hit the same bug again.

	Dave

