Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2EBKhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:37:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49398 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2EBKhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:37:54 -0400
Message-ID: <4FA10E63.5000804@kernel.dk>
Date: Wed, 02 May 2012 12:37:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com>
In-Reply-To: <4FA1092E.9090603@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 12:15 PM, Paolo Bonzini wrote:
> Il 02/05/2012 12:10, Jan Kara ha scritto:
>> Sometimes, warnings about ioctls to partition happen often enough that they
>> form majority of the warnings in the kernel log and users complain. In some
>> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
>> the warnings completely as they can ease debugging of userspace problems
>> when ioctl is refused.
>>
>> Since I have seen warnings from lots of commands, including some proprietary
>> userspace applications, I don't think disallowing the ioctls for processes
>> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
>> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> NACK.  I would bet that all the warnings you've seen are for ioctl that
> would have failed anyway with ENOTTY.
> 
> The right fix has already been posted, we've been carrying it in RHEL
> for over six months and not a single bug has been seen.

I don't remember seeing the "right" fix. The messages are really
annoying, so lets please get it resubmitted so that we can merge it.

-- 
Jens Axboe

