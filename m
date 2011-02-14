Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1BNSYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:24:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:32093 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1BNSYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:24:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,469,1291622400"; 
   d="scan'208";a="657567241"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
	<AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
	<AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
	<AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
	<m14o87wev8.fsf@fess.ebiederm.org>
	<AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
	<m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org>
	<m139nqsk3q.fsf@fess.ebiederm.org>
	<AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
Date: Mon, 14 Feb 2011 10:25:14 -0800
In-Reply-To: <AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 14 Feb 2011 08:37:21 -0800")
Message-ID: <m262smcw39.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>
> In other words: I can pretty much guarantee that this is a "struct
> list" that is in a 8kB allocation at offset 0x1748. And that gets
> re-initialized after it got freed.

If it's that the DEBUG_PAGEALLOC should have a good chance of catching
it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
