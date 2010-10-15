Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab0JOVJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:09:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36957 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab0JOVJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:09:36 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=JTWUBG3XEXkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=oakVZa-dzBQ2M5N9amgA:9 a=X0fzxm27gF8rBbASyV4A:7 a=xBf_wxTCRwx-A_SSgYSCfcBKHrgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/9] jump label: Add
 register_jump_label_key/unregister_jump_label_key
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <1287176595.1998.116.camel@laptop>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.923619508@goodmis.org>  <1287176595.1998.116.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 17:09:34 -0400
Message-ID: <1287176974.16971.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 23:03 +0200, Peter Zijlstra wrote:

> Urgh, this sucks.. :-(
> 
> So now we have to actually track all JUMP_LABEL() sites and call
> register muck on them.. even though we already track them through the
> special data section.
> 
> Is there really no way around this?

I'll take a look to see if we can monkey with magic and automate it.

-- Steve "pulling out his macro voodoo handlers" Rostedt


