Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1K1UUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:20:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:60247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab1K1UUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:20:51 -0500
Message-ID: <1322511636.2921.177.camel@twins>
Subject: Re: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control
 interface
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 21:20:36 +0100
In-Reply-To: <1322511289.17003.24.camel@frodo>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-5-git-send-email-jolsa@redhat.com>
	 <1322508398.17003.9.camel@frodo> <1322510552.2921.167.camel@twins>
	 <1322510741.2921.169.camel@twins> <1322511289.17003.24.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 15:14 -0500, Steven Rostedt wrote:
> Hmm, how many do_int3 handlers are there?
> 
Dunno, but there's the regular SIGTRAP one I guess, there's kprobes and
there's going to be uprobes. kgdb looks to be having one as well.

> Oh, I bet we could trace kprobe handlers, and this would break that.
> 
That would be lovely pain indeed ;-)
