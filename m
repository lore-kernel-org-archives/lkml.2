Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1EKQQC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:16:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab1EKQP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:15:56 -0400
Date: Wed, 11 May 2011 01:55:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during
 writeback for various fses
Message-ID: <20110511055509.GA4886@infradead.org>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
 <87tyd31fkc.fsf@devron.myhome.or.jp>
 <20110510133603.GA5823@infradead.org>
 <874o524q9h.fsf@devron.myhome.or.jp>
 <20110510144939.GI4402@quack.suse.cz>
 <87aaeur31x.fsf@devron.myhome.or.jp>
 <20110510170339.GA27538@infradead.org>
 <87liyep9fk.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87liyep9fk.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 05:50:07AM +0900, OGAWA Hirofumi wrote:
> Sounds good. So... Are you suggesting this series should use better
> approach than just blocking?

No, block reuse is a problem independent of stable pages.

