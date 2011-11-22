Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1KVOXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:23:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab1KVOXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:23:24 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Li Shaohua <shaohua.li@intel.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jens Axboe <jens.axboe@oracle.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/8] block: limit default readahead size for small devices
References: <20111121091819.394895091@intel.com>
	<20111121093846.121502745@intel.com>
	<20111121145247.0e37dc36.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Nov 2011 09:23:05 -0500
In-Reply-To: <20111121145247.0e37dc36.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 21 Nov 2011 14:52:47 -0800")
Message-ID: <x49wras44om.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> In a better world, userspace would run a
> work-out-what-readahead-size-to-use script each time a distro is
> installed and when new storage devices are added/detected.  Userspace
> would then remember that readahead size for subsequent bootups.

I'd be interested to hear what factors you think should be taken into
account by such a script.  I agree that there are certain things, like
timing of reads of different sizes, or heuristics based on the size of
installed memory, which could contribute to the default readahead size.
However, other things, like memory pressure while running the desired
workload, can't really be measured by an installer or one-time script.

> In the real world, we shovel guaranteed-to-be-wrong guesswork into the
> kernel and everyone just uses the results.  Sigh.

I'm not sure a userspace tool is the panacea you paint.  However, if you
can provide some guidance on what you think could make things better,
I'm happy to give it a go.

Cheers,
Jeff
