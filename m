Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1GLTl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:41:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42977 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1GLTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:41:28 -0400
Subject: Re: [RFC][PATCH 2/3] ftrace: Add extend-notrace to not trace sub
 funcs of notrace funcs
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110712190302.475833802@goodmis.org>
References: <20110712185131.698851699@goodmis.org>
	 <20110712190302.475833802@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 21:45:43 +0200
Message-ID: <1310499943.2309.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 14:51 -0400, Steven Rostedt wrote:
> Known issues: Things that are called from assembly are also not traced.

We could of course create a gasm CALL macro that adds the mcount hookery
and use that for those functions.

/me runs

