Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2KUKiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:38:13 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:50716 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab2KUKiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:38:10 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: trace filemap add and del
References: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
	<20121120155735.905bbf9e.akpm@linux-foundation.org>
	<20121121035924.GO2591@dastard>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 21 Nov 2012 11:38:00 +0100
In-Reply-To: <20121121035924.GO2591@dastard> (Dave Chinner's message of "Wed,
	21 Nov 2012 14:59:24 +1100")
Message-ID: <87obir5jhz.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:
> We actually have an informal convention for formating filesystem
> trace events, and that is to use the device number....
>
>> 
>> > +	),
>> > +
>> > +	TP_printk("page=%p pfn=%lu blk=%d:%d inode+ofs=%lu+%lu",
>
> ... and to prefix messages like:
>
> 	TP_printk("dev %d:%d ino 0x%llx ....
> 		  MAJOR(__entry->dev), MINOR(__entry->dev),
Right, it's sensible. I'll include that for patch V2.

> XFS, ext3/4, jbd/jdb2 and gfs2 follow this convention, so we should
> keep propagating that pattern in the name of consistency, rather
> than having different trace formats for different parts of the
> VFS/FS layers...
Very true.

Cheers.

-- 
Robert
