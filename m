Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1LMWS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:18:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab1LMWSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:18:53 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] AIO: Don't plug the I/O queue in do_io_submit()
References: <4EE7C74D.1020306@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 13 Dec 2011 17:18:41 -0500
In-Reply-To: <4EE7C74D.1020306@oracle.com> (Dave Kleikamp's message of "Tue,
	13 Dec 2011 15:44:45 -0600")
Message-ID: <x49sjkoi08u.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> Asynchronous I/O latency to a solid-state disk greatly increased
> between the 2.6.32 and 3.0 kernels. By removing the plug from
> do_io_submit(), we observed a 34% improvement in the I/O latency.
>
> Unfortunately, at this level, we don't know if the request is to
> a rotating disk or not.

I'm guessing I know the answer to this, but what workload were you
testing, and can you provide more concrete evidence than "latency
greatly increased?"  Also, have you tested the effects this has when
using traditional storage for whatever your workload is?  I don't feel
comfortable essentially reverting a performance patch without knowing
the entire picture.  I will certainly do some testing on my end, too.

Cheers,
Jeff
