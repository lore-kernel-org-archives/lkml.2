Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2B1Jja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:39:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab2B1JjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:39:19 -0500
Date: Tue, 28 Feb 2012 10:39:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] [GIT PULL][v3.3] x86: Fix up CFI for the nested NMI
Message-ID: <20120228093907.GA424@elte.hu>
References: <20120225173548.977089274@goodmis.org>
 <20120227073905.GB3397@elte.hu>
 <1330349016.25686.185.camel@gandalf.stny.rr.com>
 <20120228090638.GL21106@elte.hu>
 <4F4CA97F0200007800075205@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4CA97F0200007800075205@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 28.02.12 at 10:06, Ingo Molnar <mingo@elte.hu> wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> >> On Mon, 2012-02-27 at 08:39 +0100, Ingo Molnar wrote:
> >> > So either you do an obviously trivial patch that only adds 
> >> > CFI annotations and nothing else, or I can pull these bits 
> >> > into tip:x86/debug, for a v3.4 merge.
> >> 
> >> I'm fine with waiting for v3.4 before these changes get in.
> > 
> > Jan, is that fine with you?
> 
> Yes, absolutely (I never expected these changes to be proposed 
> for inclusion in 3.3, given that I didn't have the time to get 
> them done and submitted before -rc4).

Ok, pulled it into x86/asm for v3.4, thanks guys!

	Ingo
