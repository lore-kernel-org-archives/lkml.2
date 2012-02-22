Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2BVETO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 23:19:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:54275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab2BVETN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 23:19:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="110638607"
From: Andi Kleen <andi@firstfloor.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2 00/22] mm: lru_lock splitting
References: <20120220171138.22196.65847.stgit@zurg>
Date: Tue, 21 Feb 2012 20:19:19 -0800
In-Reply-To: <20120220171138.22196.65847.stgit@zurg> (Konstantin Khlebnikov's
	message of "Mon, 20 Feb 2012 21:22:35 +0400")
Message-ID: <m2boor33g8.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov <khlebnikov@openvz.org> writes:

Konstantin,

> There complete patch-set with my lru_lock splitting
> plus all related preparations and cleanups rebased to next-20120210

On large systems we're also seeing lock contention on the lru_lock
without using memcgs. Any thoughts how this could be extended for this
situation too?

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
