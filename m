Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab2IMJMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:12:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41114 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2IMJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:12:28 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 13 Sep 2012 11:12:26 +0200
Message-ID: <CA+icZUUi3DgkyZe57=zB2tqS95F-uwt_qGtRLjoPxd6baE6APQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 13 (input causes kernel-panic)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:22 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 201209012:
>
> The staging tree gained a conflict against the tty tree.
>
> The arm-soc tree gained a conflict against the i2c-embedded tree.
>
> The tegra tree lost 2 conflicts.
>
> The akpm tree gained 3 build failures for which I applied a merge fix
> patch and reverted 3 commits.
>
> ----------------------------------------------------------------------------
>

Unfortunately, for me an important fix did not make it into today's Linux-Next.
So, this is a warning for people (like Minchan) seeing the same kernel-panic.
( Please. follow also the discussion thread in [2] for more details. )

Thanks to all involved people!

- Sedat -

[1] https://github.com/rydberg/linux/commit/ccc6557bfd02efdca4d9dfda6cfdfe5a08d0193b
[2] http://marc.info/?t=134751435100001&r=1&w=2
