Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2E3UbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:31:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:18062 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2E3UbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:31:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158851599"
From: Andi Kleen <andi@firstfloor.org>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        hughd@google.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/6] mempolicy: Kill all mempolicy sharing
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
	<1338368529-21784-3-git-send-email-kosaki.motohiro@gmail.com>
Date: Wed, 30 May 2012 13:31:22 -0700
In-Reply-To: <1338368529-21784-3-git-send-email-kosaki.motohiro@gmail.com>
	(kosaki motohiro's message of "Wed, 30 May 2012 05:02:05 -0400")
Message-ID: <m2vcjdjtr9.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kosaki.motohiro@gmail.com writes:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> Dave Jones' system call fuzz testing tool "trinity" triggered the following
> bug error with slab debugging enabled

We have to fix it properly sorry. There are users who benefit from it
and just disabling it is not gonna fly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
