Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0JOJl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:41:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab0JOJl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:41:26 -0400
Date: Fri, 15 Oct 2010 11:41:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][GIT PULL] ftrace: Rename config option
 HAVE_C_MCOUNT_RECORD to HAVE_C_RECORDMCOUNT
Message-ID: <20101015094119.GA21002@elte.hu>
References: <1287114319.23682.34.camel@gandalf.stny.rr.com>
 <20101015041307.GA31764@elte.hu>
 <20101015073836.GA6870@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015073836.GA6870@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, a recent tracing change causes this new warning on latest -tip:

It appears it has been there for a longer time. So not caused by a 
recent commit - but it's a real warning nevertheless.

	Ingo
