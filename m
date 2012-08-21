Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2HUH4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:56:38 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54175 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2HUH4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:56:33 -0400
Date: Tue, 21 Aug 2012 09:56:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20120821075628.GA11067@gmail.com>
References: <20120820091222.GA9486@gmail.com>
 <CA+55aFw1peyignpmjYBJbF2t1EuRLw-dBKoEsKVcOi7rTY5iWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw1peyignpmjYBJbF2t1EuRLw-dBKoEsKVcOi7rTY5iWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Aug 20, 2012 at 2:12 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest sched-urgent-for-linus git tree from:
> 
> Ingo, *please* get into the habit of writing a short explanation for
> your pull request so that my merge messages can be more relevant, ok?

Yeah, sorry:

Small assorted fixlets, plus a lock contention fix which we felt 
rises to the level of needing a fix in -rc.

Thanks,

	Ingo
