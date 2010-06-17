Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617Ab0FQSP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:15:56 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50328 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927Ab0FQSPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:15:55 -0400
Message-ID: <4C1A6658.1070704@kernel.dk>
Date: Thu, 17 Jun 2010 20:15:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, carns@mcs.anl.gov
Subject: Re: [patch] cfq: Don't allow queue merges for queues that have no
 process references
References: <x49ocf9agio.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ocf9agio.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-17 16:19, Jeff Moyer wrote:
> Hi,
> 
> A user reported a kernel bug when running a particular program that did
> the following
> 
> created 32 threads
> - each thread took a mutex, grabbed a global offset, added a buffer size
>   to that offset, released the lock
> - read from the given offset in the file
> - created a new thread to do the same
> - exited

[snip]

Thanks for doing the excellent writeup and nailing this bug, I'll commit
it and mark it for -stable.

-- 
Jens Axboe

