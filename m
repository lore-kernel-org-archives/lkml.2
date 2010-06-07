Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0FGQVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:21:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40318 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0FGQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 12:21:30 -0400
To: Dave Chinner <david@fromorbit.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
	<yq11vcqlwp8.fsf@sermon.lab.mkp.net>
	<20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
	<20100602232039.GA8287@dastard> <yq139x3y411.fsf@sermon.lab.mkp.net>
	<20100604023253.GF19651@dastard>
Date: Mon, 07 Jun 2010 12:20:13 -0400
In-Reply-To: <20100604023253.GF19651@dastard> (Dave Chinner's message of "Fri,
	4 Jun 2010 12:32:53 +1000")
Message-ID: <yq1zkz6vmpu.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4C0D1C7A.00F8:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

>> Didn't you use to wait_on_page_writeback() in page_mkwrite()?

Dave> The generic implementation of ->page_mkwrite
Dave> (block_page_mkwrite()) which XFS uses has never had a
Dave> wait_on_page_writeback() call in it.  There's no call in the
Dave> generic write paths, either, hence my comment that only direct IO
Dave> on XFS will work.

I guess that wait_on_page_writeback() was something I added when I used
XFS for DIF testing.

-- 
Martin K. Petersen	Oracle Linux Engineering
