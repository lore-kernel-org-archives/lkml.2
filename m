Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1BDObS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 09:31:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1BDObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 09:31:17 -0500
Subject: Re: Using ftrace/perf as a basis for generic seccomp
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Stefan Fritsch <sf@sfritsch.de>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, agl@google.com, tzanussi@gmail.com,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, James Morris <jmorris@namei.org>
In-Reply-To: <1296784230.3145.44.camel@localhost.localdomain>
References: <1294867725.3237.230.camel@localhost.localdomain>
	 <1296665124.3145.17.camel@localhost.localdomain>
	 <20110203190643.GC1769@nowhere> <201102032306.34251.sf@sfritsch.de>
	 <20110203231051.GA1840@nowhere>
	 <1296784230.3145.44.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 15:31:55 +0100
Message-ID: <1296829915.26581.658.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 20:50 -0500, Eric Paris wrote:
> I'm going to try to work on it over
> the next week or two.  

What is your use-case? Going by: http://lwn.net/Articles/332990/ syscall
based stuff (seccomp) is broken by design.

