Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab1ERSRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:17:37 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:33057 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709Ab1ERSRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:17:34 -0400
Date: Wed, 18 May 2011 14:16:57 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [4/7] ext4: Clean up some wait_on_page_writeback calls
Message-ID: <20110518181657.GA13693@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jeff Layton <jlayton@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	Chris Mason <chris.mason@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
References: <20110509230349.19566.27020.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509230349.19566.27020.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 01:03:49PM -0000, Darrick J. Wong wrote:
> wait_on_page_writeback already checks the writeback bit, so callers of it
> needn't do that test.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Added to the ext4 tree, thanks.

						- Ted
