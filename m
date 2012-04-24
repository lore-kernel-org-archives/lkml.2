Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2DXTjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:39:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44883 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab2DXTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120424162224.454623618@chello.nl>
References: <20120424161039.293018424@chello.nl> <20120424162224.454623618@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Apr 2012 12:39:24 -0700
X-Google-Sender-Auth: YWnmsfg4zCz1XGs6zGW62dzWn5o
Message-ID: <CA+55aFyPG5pUOTb9-cNGFsBc-BLfWqLEbgnWbz528-Gs6miSUg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] kernel,sched,time: Clean up gcc work-arounds
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 9:10 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> +#define __gcc_dont_optimize_loop(var) asm("" "+rm" (var))

This seems to be missing a colon.

               Linus
