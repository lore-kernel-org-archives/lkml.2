Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1LIBqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:46:43 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61862 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1LIBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:46:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111209123811.12cf28971f21a309976f31bb@canb.auug.org.au>
References: <20111209123811.12cf28971f21a309976f31bb@canb.auug.org.au>
Date: Thu, 8 Dec 2011 20:46:39 -0500
Message-ID: <CA+5PVA5vVC=e24imM0QxbT10kBAF4v=kwheKs7cOHKKcC+if=A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the 4xx tree with the powerpc tree
From: Josh Boyer <jwboyer@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Tanmay Inamdar <tinamdar@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 8:38 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Josh,
>
> Today's linux-next merge of the 4xx tree got a conflict in
> arch/powerpc/platforms/40x/ppc40x_simple.c between commit 11eab297f57b
> ("powerpc: Add support for OpenBlockS 600") from the powerpc tree and
> commit d5b9ee7b514e ("powerpc/40x: Add APM8018X SOC support") from the
> 4xx tree.

I blame BenH.  I sent him a pull request with d5b9ee7b514e in it
before he went and updated his tree.  Still not pulled afaik.  Guess
I'll be rebasing my next branch tomorrow to pick up a series from Tony
Breeds, unless Ben handles the outstanding pull before I wake up :).

> I fixed it up (see below) and can carry the fix as necessary.

Looks correct to me.  Hopefully you won't have to carry it long.
>
> [Josh: I have changed you contact address to the above]

Thank you.

josh
