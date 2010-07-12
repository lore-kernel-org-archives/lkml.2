Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0GLRUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188Ab0GLRUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <4C3B49B4.20300@panasas.com>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
	<201007052325.56971.rjw@sisk.pl>
	<4C3B49B4.20300@panasas.com>
Date: Mon, 12 Jul 2010 10:20:08 -0700
Message-ID: <AANLkTik8MD7bWb_R38MGv3H6ct-Z3ee1x9i9sn5a_ohd@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc4 - CONFIG_LOCALVERSION ignored?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Michal Marek <mmarek@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/12 Benny Halevy <bhalevy@panasas.com>:
>
> Not working for me either in 2.6.35-rc4.

I assume you're building with "O="? If so, have you checked -git (or
any of the nightly snapshots)?

Becuse it _should_ have been fixed about a week ago in commit
7263e715c91f ("kbuild: Fix path to scripts/setlocalversion"). But
that's after -rc4.

(I'll do an -rc5 probably today, but it would be good to have it
confirmed that the bug is gone)

               Linus
