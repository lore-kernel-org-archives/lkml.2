Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1HAHB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 03:01:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41960 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1HAHBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 03:01:22 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110801144732.7f5204b219f628f2a2a63b0c@canb.auug.org.au>
References: <20110801144732.7f5204b219f628f2a2a63b0c@canb.auug.org.au>
Date: Mon, 1 Aug 2011 09:01:21 +0200
Message-ID: <CA+icZUXq9V6h6kJrjckpeDXQAbQ-skiKLwTjD7Luhz1mTqSM1w@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 6:47 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Just in case anyone needs reminding:  Please do not add anything destined
> for v3.2 into linux-next included trees until after v3.1-rc1.
>
> The powerpc allyesconfig build (at least) fails today.
>
> Changes since 20110729:
>
> Linus' tree still lost its build failure.
>
> The v4l-dvb tree lost its conflicts.
>
> The kgdb tree gained a build failure for which I reverted 3 commits.
>
> The moduleh tree gained a conflict against the slabe-dma tree but lost
> its build failures (except for a few remaining merge fixups).
>
> ----------------------------------------------------------------------------
>

Just FYI: mmotm-tree still misses the fixup-patch from [1].

- Sedat -

[1] https://patchwork.kernel.org/patch/1021602/
