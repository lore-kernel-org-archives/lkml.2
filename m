Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab1JYNJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:09:30 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38467 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213Ab1JYNJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:09:28 -0400
Date: Tue, 25 Oct 2011 09:09:24 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] ext4: ext4_mkdir should dirty dir_block with the
 parent inode
Message-ID: <20111025130924.GI31921@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
 <20111021211812.10784.27324.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021211812.10784.27324.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:18:12PM -0700, Darrick J. Wong wrote:
> ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
> Unfortunately, dir_block belongs to the newly created directory (which is
> "inode"), not the parent directory (which is "dir").  Fix the incorrect
> association.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This is already checked in (git commit: f9287c1f2d3 in the master branch).

     			   		- Ted
