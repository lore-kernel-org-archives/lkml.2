Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab1BWUY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:24:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38414 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1BWUY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:24:58 -0500
Date: Wed, 23 Feb 2011 12:24:47 -0800
From: Joel Becker <jlbec@evilplan.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: djwong@us.ibm.com, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Message-ID: <20110223202446.GG4020@noexit>
Mail-Followup-To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	djwong@us.ibm.com, Jens Axboe <axboe@kernel.dk>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>,
	linux-scsi <linux-scsi@vger.kernel.org>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:45:44AM -0500, Martin K. Petersen wrote:
> Also, DIX is only the tip of the iceberg. Many other impending
> technologies feature checksums and require pages to be stable during I/O
> due to checksumming, encryption and so on.
> 
> The VM is already trying to do the right thing. We just need the
> relevant filesystems to catch up.

	ocfs2 handles stable metadata for its checksums when feeding
things to the journal.  If we're doing pagecache-based I/O, is the
pagecache going to help here for data?
 
Joel

-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

			http://www.jlbec.org/
			jlbec@evilplan.org
