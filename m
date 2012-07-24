Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2GXUwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:52:46 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:32952 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab2GXUwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:52:42 -0400
X-Auth-Info: 76rer/bqGDHpaf2vMSm0fOmw/lJqQXe8hFEOIXZBjKM=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Jeff Law <law@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
References: <20120724181209.GA10534@zod.bos.redhat.com>
	<CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
	<20120724182409.GB10534@zod.bos.redhat.com>
	<500EF541.50009@redhat.com>
	<CA+55aFwSHae5rgFP_b_+r9Agz9JfM9QdoNbZTq7u+5G-xrr8RQ@mail.gmail.com>
	<20120724194124.GF10534@zod.bos.redhat.com>
	<CA+55aFxYe64cNUNc5Xsz3R34nLynhWri=7konGGgM9iNHFVuFg@mail.gmail.com>
	<CA+55aFwUi8Zg_WGtOdJcvpQa9yLH0fOU0pfOKGoAgtnJdOqrSg@mail.gmail.com>
X-Yow: ..  If I had heart failure right now, I couldn't be a more fortunate man!!
Date: Tue, 24 Jul 2012 22:52:38 +0200
In-Reply-To: <CA+55aFwUi8Zg_WGtOdJcvpQa9yLH0fOU0pfOKGoAgtnJdOqrSg@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 24 Jul 2012 13:11:49 -0700")
Message-ID: <m2k3xsswyx.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> But even before they were removed, they were inside #ifdef __KERNEL__
> protection, so it wasn't available to user code.

They used to be exported for __GLIBC__ < 2, but that was removed in
2008.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
