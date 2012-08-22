Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab2HVUXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:23:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:4620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab2HVUXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:23:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,296,1344236400"; 
   d="scan'208";a="136911374"
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 v2] HWPOISON: improve dirty pagecache error reporting
References: <1345648655-4497-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Wed, 22 Aug 2012 13:22:36 -0700
In-Reply-To: <1345648655-4497-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	(Naoya Horiguchi's message of "Wed, 22 Aug 2012 11:17:32 -0400")
Message-ID: <m2obm27k37.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> Hi,
>
> Based on the previous discussion, in this version I propose only error
> reporting fix ("overwrite recovery" is sparated out from this series.)
>
> I think Fengguang's patch (patch 2 in this series) has a corner case
> about inode cache drop, so I added patch 3 for it.

New patchkit looks very reasonable to me.

I haven't gone through all the corner cases the inode pinning may
have though. You probably want an review from Al Viro on this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
