Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1HLSZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 14:25:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:10687 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab1HLSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 14:25:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,363,1309762800"; 
   d="scan'208";a="6603282"
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: NACK! Re: [PATCH 4/4] Add vsyscalls to feature-removal-schedule.txt
References: <cover.1312899174.git.luto@mit.edu>
	<066852f3f344c1733e0db9a2427981ea1815db7d.1312899174.git.luto@mit.edu>
Date: Fri, 12 Aug 2011 11:25:15 -0700
In-Reply-To: <066852f3f344c1733e0db9a2427981ea1815db7d.1312899174.git.luto@mit.edu>
	(Andy Lutomirski's message of "Tue, 9 Aug 2011 10:27:50 -0400")
Message-ID: <m24o1mmqr8.fsf_-_@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@MIT.EDU> writes:

> In a couple years, we'll see how well we've done at eradicating vsyscall-using
> binaries.  Hopefully we can then disable them by default.  We will probably
> have to leave the option to enable them around forever.

NACK NACK NACK!

this would break all old (old = meaning all today's) x86-64 installations. 

Sorry but I don't think feature removal should be ever for anything
commonly used, especially not for anything used by nearly 
EVERY binary on an old installation. We usually use it 
for obscure things used rarely.

Repeat after me: BINARY COMPATIBILITY is important.
It's not a joke. It's not a toy. It's one of the basic values
of Linux.

Sorry to be honest I don't know how you can even suggest
such a thing with a straight face.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
