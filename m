Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2AHLeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:34:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37232 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab2AHLep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:34:45 -0500
Date: Sun, 8 Jan 2012 12:32:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        stable <stable@kernel.org>
Subject: Re: [PATCH][GIT PULL] recordmcount: Fix handling of elf64 big-endian
 objects
Message-ID: <20120108113230.GA26516@elte.hu>
References: <1325906151.7642.20.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325906151.7642.20.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: 2e885057b7f75035f0b85e02f737891482815a81
> 
> 
> David Daney (1):
>       recordmcount: Fix handling of elf64 big-endian objects
> 
> ----
>  scripts/recordmcount.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
