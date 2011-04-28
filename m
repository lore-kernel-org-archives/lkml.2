Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab1D1TXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab1D1TXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:23:11 -0400
Subject: Re: [PATCH] jump label: Fix jump_label_text_reserved
From: Steven Rostedt <srostedt@redhat.com>
To: Anders Kaseorg <andersk@ksplice.com>
Cc: Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTikG6atUB1mE8UF8Ew4ustb1gfFEjA@mail.gmail.com>
References: <alpine.DEB.2.02.1104281346060.14343@dr-wily.mit.edu>
	 <20110428184234.GB2559@redhat.com>
	 <BANLkTikG6atUB1mE8UF8Ew4ustb1gfFEjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Thu, 28 Apr 2011 15:22:56 -0400
Message-ID: <1304018576.4401.21.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 15:10 -0400, Anders Kaseorg wrote:
> On Thu, Apr 28, 2011 at 14:42, Jason Baron <jbaron@redhat.com> wrote:
> > This is fixed in the jump label re-write patch, which is queued for
> > 2.6.40 in the -tip tree. See: http://marc.info/?l=linux-kernel&m=130391786701337&w=2
> 
> Okay.  It would be nice if the bug fixes had been separated out into

I didn't realize this was a bug fix that was noticed by current users,
otherwise I would have done so.

> commits that could be picked onto the -stable kernels.  Should I send
> my patch to stable@kernel.org?
> 
> > I believe only kprobes is relying on this check. Did you hit this in
> > practive using kprobes?
> 

If you do, note that it is pending in tip and give the commit id for it.
It will make stable as soon as the commit makes it in mainline in
the .40 merge window.

If possible we could cherry pick the patch for mainline to get it in
sooner, and it would just be a wash when it goes in with the current tip
branch.

-- Steve


