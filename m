Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2INL4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:56:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38198 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab2INL4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:56:02 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120914173813.fa65528e5236bd0a20c29b92@canb.auug.org.au>
References: <20120914173813.fa65528e5236bd0a20c29b92@canb.auug.org.au>
Date: Fri, 14 Sep 2012 13:56:01 +0200
Message-ID: <CA+icZUUWwaysVRHFWKfw6Renj2rAW8VZHrQhHy78-cpBQ+07fQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 14
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 9:38 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 201209013:
>
> The pci tree lost its conflicts.
>
> The i2c tree lost its conflict.
>
> The net-next tree gained conflicts against the net tree.
>
> The cgroup tree gained a build failure so I used the version from
> next-20120913.
>
> The workqueues tree gained a conflict against the net tree.
>
> The dma-mapping tree gained conflicts against the libata tree.
>
> The clk tree lost its conflicts.
>
> The akpm tree lost 2 build failures, I have still reverted 1 commit.
>
> ----------------------------------------------------------------------------
>

This is a good release (for me), thanks :-).
Wonderful, wonderful, wonderful life... [1].
( If linux-next folks would get all (severe) issues tracked down
within a week till Fridays (which is a challenge)... )

- Sedat -

[1] http://www.youtube.com/watch?v=pj_qIwQ3V5c
