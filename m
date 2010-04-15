Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0DONN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:13:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab0DONN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:13:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       vgoyal@redhat.com
Subject: Re: [PATCH 0/4 v3] ext3/4: enhance fsync performance when using CFQ
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
	<20100415103345.GY27497@kernel.dk>
	<x498w8oj276.fsf@segfault.boston.devel.redhat.com>
	<20100415130854.GA27497@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 15 Apr 2010 09:13:51 -0400
In-Reply-To: <20100415130854.GA27497@kernel.dk> (Jens Axboe's message of "Thu,
	15 Apr 2010 15:08:55 +0200")
Message-ID: <x494ojcj1tc.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> > This is starting to look better. Can you share what tests you did? I
>> > tried reproducing with fs_mark last time and could not.
>> 
>> Did you use the fs_mark command line I (think I) had posted?  What
>> storage were you using?
>
> No, I didn't see any references to example command lines. I tested on a
> few single disks, rotating and SSD. I expected the single spinning disk
> to show the problem to some extent at least, but there was no difference
> observed with 64kb blocks.

Boy, I'm really slipping.  Try this one:

./fs_mark -S 1 -D 100 -N 1000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096

Cheers,
Jeff
