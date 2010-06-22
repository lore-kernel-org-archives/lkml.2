Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0FVWOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:14:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab0FVWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:14:51 -0400
Date: Tue, 22 Jun 2010 15:13:07 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when
 using CFQ
Message-ID: <20100622221306.GA20090@mail.oracle.com>
Mail-Followup-To: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk,
	vgoyal@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C2135CD.012B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 05:34:59PM -0400, Jeff Moyer wrote:
> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
> far worse than that of deadline for enterprise class storage when dealing
> with file sizes of 8MB or less.  I used the following command line as a
> representative test case:
> 
>   fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096 -F

	I'd be interested in how ocfs2 does, because we use jbd2 too.

Joel

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
