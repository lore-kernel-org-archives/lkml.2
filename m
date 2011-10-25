Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab1JYNIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:08:41 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38463 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213Ab1JYNIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:08:40 -0400
Date: Tue, 25 Oct 2011 09:08:30 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] ext4: ext4_rename should dirty dir_bh with the
 correct directory
Message-ID: <20111025130829.GH31921@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20111021211759.10784.17257.stgit@elm3c44.beaverton.ibm.com>
 <20111021211806.10784.76743.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021211806.10784.76743.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:18:06PM -0700, Darrick J. Wong wrote:
> When ext4_rename performs a directory rename (move), dir_bh is a buffer that is
> modified to update the '..' link in the directory being moved (old_inode).
> However, ext4_handle_dirty_metadata is called with the old parent directory
> inode (old_dir) and dir_bh, which is incorrect because dir_bh does not belong
> to the parent inode.  Fix this error.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This was already merged (git commit: bcaa9929750 in the master branch).

     	 	 	     	     		 - Ted
