Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2FOKvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:51:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54961 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab2FOKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:51:40 -0400
Message-ID: <4FDB13B1.8040100@kernel.dk>
Date: Fri, 15 Jun 2012 12:51:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
References: <1339757457-15646-1-git-send-email-jack@suse.cz>
In-Reply-To: <1339757457-15646-1-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 12:50 PM, Jan Kara wrote:
> Sometimes, warnings about ioctls to partition happen often enough that they
> form majority of the warnings in the kernel log and users complain. In some
> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> the warnings completely as they can ease debugging of userspace problems
> when ioctl is refused.
> 
> Since I have seen warnings from lots of commands, including some proprietary
> userspace applications, I don't think disallowing the ioctls for processes
> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.

Agree, merged, finally.

-- 
Jens Axboe

