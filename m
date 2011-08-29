Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1H2Gwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 02:52:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42558 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1H2Gwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 02:52:34 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
References: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
Date: Mon, 29 Aug 2011 08:52:29 +0200
Message-ID: <CA+icZUWHaVCaBwPm0+A9=2hfY8xOjRFM3XJ6_tOqSyKun-MOQA@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 29
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 8:19 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> The powerpc allyesconfig build still fails today.
>
> Changes since 20110826:
>
> New tree: iommu
>
> Dropped tree: iommu (build failure)
>
> Linus' tree gained build failures for which I applied 2 patches.
>
> The arm-soc tree gained a conflict against the arm tree.
>
> The scsi tree gained a build failure, so I used the version from
> next-20110826.
>
> The net tree lost 2 conflicts.
>
> The iommu tree gained a build failure so I dropped it.
>
> I have still reverted the x86/spinlocks branch from the tip tree for
> today.
>
> The driver-core tree gained a conflict against the arm-soc tree.
>
> The tty tree lost its build failure.
>
> The moduleh tree lost 2 conflicts.
>
> The akpm tree gained conflicts agains Linus' tree - I dropped several
> patches that had been merged upstream.
>
> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).

Might be time to store next patch in .../v3.x/next/ or a new own
http://www.kernel.org/pub/linux/kernel/next/ upload-dir?

- Sedat -
