Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1FNQhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:37:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24420 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1FNQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:37:13 -0400
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 3/4] Staging: zram: allow partial page operations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
	<1307712529-9757-2-git-send-email-jmarchan@redhat.com>
	<1307712529-9757-3-git-send-email-jmarchan@redhat.com>
	<4DF2493F.8040507@vflare.org> <4DF5DB79.3010004@redhat.com>
	<x49aadk31u1.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 14 Jun 2011 12:36:53 -0400
In-Reply-To: <x49aadk31u1.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Tue, 14 Jun 2011 10:49:26 -0400")
Message-ID: <yq1fwnc5pzu.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4DF78E32.0152:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

Jeff> I don't think there's any reason the logical block size can't be
Jeff> increased.  For zram, so long as you don't care that the minimum
Jeff> I/O size is 64k on these systems (and by you, I mean the users of
Jeff> zram, like file systems, or anything using the block device
Jeff> directly), then it's a fine trade-off to make.

Jeff> Jens, Martin, what do you guys think about bumping the size of the
Jeff> queue_limits.logical_block_size?

When I wrote the code I thought 64K ought to be enough for anybody.

I don't have a problem bumping it as long as people are aware of the
implications bigger blocks have on the filesystems they put on top.

-- 
Martin K. Petersen	Oracle Linux Engineering
