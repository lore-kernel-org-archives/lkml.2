Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1KEQ3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 12:29:31 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50857 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1KEQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 12:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <1320458934-8225-1-git-send-email-kgene.kim@samsung.com>
References: <1320458934-8225-1-git-send-email-kgene.kim@samsung.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Nov 2011 09:29:08 -0700
X-Google-Sender-Auth: I8_wyRVsyB8WI_a92hvMCOYVMXM
Message-ID: <CA+55aFw8mxcwukXWe-DRYYv3tWmM6gRebgAGxAMpDLbqhqK2-Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS4: Fix the merge conflict
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 7:08 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> The mark of conflict should be removed.
>
> This happened at the commit fba9569924e06da076cb2ad12474bbd82d69f54d
> ("Merge branch 'next' of git://git.infradead.org/users/vkoul/slave-dma")

Grr. I'm a moron. I had fixed the conflict above it, and for some
reason didn't notice the second conflict.

I *always* do a "git diff" to check my conflict resolution
after-the-fact before I add it, but obviously I skipped that step this
time.

Blush.

Thanks,

                Linus
