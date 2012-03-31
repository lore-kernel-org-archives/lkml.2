Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab2CaOHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 10:07:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:3665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351Ab2CaOG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125574254"
From: Andi Kleen <andi@firstfloor.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/7] mm: vma->vm_flags diet
References: <20120331091049.19373.28994.stgit@zurg>
Date: Sat, 31 Mar 2012 07:06:30 -0700
In-Reply-To: <20120331091049.19373.28994.stgit@zurg> (Konstantin Khlebnikov's
	message of "Sat, 31 Mar 2012 13:25:36 +0400")
Message-ID: <m2ty14yie1.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov <khlebnikov@openvz.org> writes:

> This patch-set moves/kills some VM_* flags in vma->vm_flags bit-field,
> as result there appears four free bits.
>
> Also I'm working on VM_RESERVED reorganization, probably it also can be killed.
> It lost original swapout-protection sense in 2.6 and now is used for other purposes.

Great, I ran into this problem recently too: I wanted to add a new bit,
but there was none.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
