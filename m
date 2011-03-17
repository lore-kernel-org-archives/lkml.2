Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1CQW5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:57:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:21150 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1CQW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="404375331"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: make checkpatch warn about memset with swapped arguments.
References: <20110317045209.GA18656@redhat.com>
Date: Thu, 17 Mar 2011 15:56:24 -0700
In-Reply-To: <20110317045209.GA18656@redhat.com> (Dave Jones's message of
	"Thu, 17 Mar 2011 00:52:09 -0400")
Message-ID: <m2wrjxtkyv.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> Because the second and third arguments of memset have the same type,
> it turns out to be really easy to mix them up.
>
> This bug comes up time after time, so checkpatch should really
> be checking for it at patch submission time.

Or we just readd an optimized bzero() and recommend people use that
instead of memset for zero? And then there won't be too many users left.

I always felt classic BSD was much more sensible regarding this than
ANSI-C.

It's better to avoid errors in the first place than to check for
them later.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
