Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1COWbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:31:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab1COWbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:31:09 -0400
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 23:32:54 +0100
Message-ID: <1300228374.2250.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right, so I don't much like the interface, two new ioctl()s and a flag
of dubious use.

How important is this recursive nature of the thing to you:

> It's supposed to support infinite combinations with starter having starters
> themselves, plus filters, etc...

We've so far avoided recursion like that, we only have single level
groups etc.



