Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2HUH7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:59:23 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49141 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2HUH7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:59:20 -0400
Date: Tue, 21 Aug 2012 09:59:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20120821075915.GA11135@gmail.com>
References: <20120820090819.GA8047@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820090819.GA8047@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Linus,
> 
> Please pull the latest perf-urgent-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
> 
>    HEAD: 26a4f3c08de49c1437a7b7f97693cf22d8c31656 perf/x86: disable PEBS on a guest entry.

The missing description:

Small fixes for merge window fallout, plus a (smallish)
hw-enablement patch for the new uncore PMU driver,
enabling Intel Westmere-EX support.

Thanks,

	Ingo
