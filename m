Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab1JYNNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:13:31 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59781 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab1JYNN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:13:28 -0400
Date: Tue, 25 Oct 2011 09:13:24 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] ext4: ext4_dx_add_entry should dirty directory
 metadata with the directory inode
Message-ID: <20111025131324.GJ31921@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:17:59PM -0700, Darrick J. Wong wrote:
> ext4_dx_add_entry manipulates bh2 and frames[0].bh, which are two buffer_heads
> that point to directory blocks assigned to the directory inode.  However, the
> function calls ext4_handle_dirty_metadata with the inode of the file that's
> being added to the directory, not the directory inode itself.  Therefore,
> correct the code to dirty the directory buffers with the directory inode, not
> the file inode.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This has been accpeted into the ext4 tree already (git commit:
5930ea643 in the master branch)

						- Ted
