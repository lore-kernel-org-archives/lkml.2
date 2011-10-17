Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1JQW4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:56:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34184 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab1JQW4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:56:07 -0400
Date: Mon, 17 Oct 2011 18:53:57 -0400 (EDT)
Message-Id: <20111017.185357.1185691091043314919.davem@davemloft.net>
To: dpmcgee@gmail.com
Cc: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/mm: remove hack in mmap randomize layout
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAEik5nPXQXESnNLJCWd48LLiEYsN6MgnjKhd_a4SMHFGHBbm8w@mail.gmail.com>
References: <1318882661-26859-1-git-send-email-dpmcgee@gmail.com>
	<20111017.175141.1489173261757833533.davem@davemloft.net>
	<CAEik5nPXQXESnNLJCWd48LLiEYsN6MgnjKhd_a4SMHFGHBbm8w@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 17 Oct 2011 15:54:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan McGee <dpmcgee@gmail.com>
Date: Mon, 17 Oct 2011 17:43:11 -0500

> Aha, I wasn't aware this was also being done elsewhere as there was no
> comment to tip me off. I found the one in
> arch/sparc/kernel/sys_sparc_64.c (mmap_rnd) and have fixed that
> locally and will resend, but I'm not seeing get_random_int() in use
> anywhere else in that architecture so I'm not quite sure where your
> second mentioned location is- or did you just mean the two calls 2
> lines apart in mmap_rnd()?

My bad, I thought we had implemented address randomization on 32-bit
sparc as well, unfortunately we haven't even though sparc64 has it
for 32-bit compat tasks.

That should be fixed at some point, but is outside of the scope of
what you're doing.

Thanks!
