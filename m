Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab1E0QUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:20:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33218 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1E0QUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:20:52 -0400
Date: Fri, 27 May 2011 09:20:00 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Theodore Tso <tytso@mit.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCHSET v3.2 0/3] data integrity: Stabilize pages during
	writeback for various fses
Message-ID: <20110527162000.GV18929@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110519224841.28755.80650.stgit@elm3c44.beaverton.ibm.com> <20110527073326.GA15405@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527073326.GA15405@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 03:33:26AM -0400, Christoph Hellwig wrote:
> Can you resend patches 1 and 2 ontop of current Linus' tree with Jans
> page_mkwrite changes?  I don't think there's much point of patch 3 until
> we get a user for simple_page_mkwrite.

Sure thing.  I'll have something ready by the afternoon (here).

--D
