Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0FANSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:18:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45500 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab0FANSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:18:20 -0400
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
Date: Tue, 01 Jun 2010 09:16:35 -0400
In-Reply-To: <20100531144648.GA19068@schmichrtp.mainz.de.ibm.com> (Christof
	Schmitt's message of "Mon, 31 May 2010 16:46:49 +0200")
Message-ID: <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090205.4C050899.00D2:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:

>> Yep, known bug.  Page writeback locking is messed up for buffer_head
>> users.  The extNfs folks volunteered to look into this a while back
>> but I don't think they have found the time yet.

Christof> Thanks for the info. This means that this bug appears with all
Christof> filesystems?

XFS and btrfs should be fine.

-- 
Martin K. Petersen	Oracle Linux Engineering
