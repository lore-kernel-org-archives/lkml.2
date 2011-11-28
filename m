Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1K1UOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:14:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55404 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1K1UOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:14:51 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=6ethm6nK9TkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=jzmDrJgOCPuE0NtnOycA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 4/9] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <1322510741.2921.169.camel@twins>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-5-git-send-email-jolsa@redhat.com>
	 <1322508398.17003.9.camel@frodo> <1322510552.2921.167.camel@twins>
	 <1322510741.2921.169.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 15:14:49 -0500
Message-ID: <1322511289.17003.24.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 21:05 +0100, Peter Zijlstra wrote:

> Note that this of course precludes ever using jump_labels from do_int3
> handlers ;-)

Hmm, how many do_int3 handlers are there?

Oh, I bet we could trace kprobe handlers, and this would break that.

I'm a bit nervous about adding jump_labels into function tracing
handlers.

-- Steve

