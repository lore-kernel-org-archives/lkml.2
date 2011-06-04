Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1FDVRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 17:17:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab1FDVRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 17:17:16 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=sBfRri4=rQX2YCqMNnaQK-SAsUA@mail.gmail.com>
References: <BANLkTi=sBfRri4=rQX2YCqMNnaQK-SAsUA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 Jun 2011 06:16:21 +0900
Message-ID: <BANLkTinh+CbCrGA_0__msbNuVOBF+d3vkw@mail.gmail.com>
Subject: Re: Revert "slub: Remove node check in slab_free"
To: sedat.dilek@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 4, 2011 at 5:38 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> What happened to that revert-patch?
> ( Not in -tip... not in -slab... not in mainline. )
>
> - Sedat -
>
> [1] https://patchwork.kernel.org/patch/815332/

It was fixed without reverting by commit a71ae47a2cbf ("slub: Fix
double bit unlock in debug mode")

                                Linus
