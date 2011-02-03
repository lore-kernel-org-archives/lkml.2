Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1BCAoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:44:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39632 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1BCAoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:44:18 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=v-yzS0rkWj0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VO9mzP3fE9nYVZkDG4AA:9 a=XKhpiZzKfJBFxyevGWrO4xhYQ_4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] [GIT PULL][v2.6.38]: tracing: alignment fixes
 (take 2)
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20110202180613.978219945@goodmis.org>
References: <20110202180613.978219945@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 02 Feb 2011 19:44:16 -0500
Message-ID: <1296693856.10797.76.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 13:06 -0500, Steven Rostedt wrote:
> Ingo,
> 
> OK, this time I ran this under x86_64 and x86_32 with gcc-4.5.1
> and gcc-4.4.5. It even found a bug, that I had to fix and retest.
> 

Hi Ingo,

I'm rebasing to fix up some commit logs. I'll post a new patch set
tonight or tomorrow. It will also include a third patch that fixes the
syscall metadata.

-- Steve


