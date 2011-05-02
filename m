Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1EBRHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:07:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54989 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1EBRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:07:39 -0400
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 3/3] blkdev: honor discard_granularity in blkdev_issue_discard()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
	<1304345841-20063-3-git-send-email-lczerner@redhat.com>
	<yq17ha94175.fsf@sermon.lab.mkp.net>
	<x49aaf5ozge.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 02 May 2011 13:07:27 -0400
In-Reply-To: <x49aaf5ozge.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 02 May 2011 12:10:41 -0400")
Message-ID: <yq1pqo12fqo.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DBEE4D5.009F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

Jeff> Hm, I wonder where it makes sense to document this.  Maybe
Jeff> Documentation/block/queue-sysfs.txt, but I admit I wouldn't have
Jeff> looked there while reviewing this code.

Maybe we could simply add a comment in the kerneldoc header for
blkdev_issue_discard()?

I tried to keep Documentation/ABI/ up to date for the topology stuff but
it looks like the discard portions never got merged. Probably fell
through the cracks. I'll dig up the patch.

But as you say -- I'm sure nobody looks. My only motivation for keeping
the sysfs ABI doc in sync is to avoid gregkh's wrath...

-- 
Martin K. Petersen	Oracle Linux Engineering
