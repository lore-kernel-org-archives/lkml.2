Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1DZNTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:19:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1DZNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:19:21 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=praKMrWUFPEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=6Y-QjnKjbjFOJVtHJ04A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/6] [GIT PULL][v2.6.40] tracing: updates and jump
 label rebase
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20110420155838.640017971@goodmis.org>
References: <20110420155838.640017971@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 09:19:19 -0400
Message-ID: <1303823959.18763.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 11:58 -0400, Steven Rostedt wrote:
> Ingo,
> 
> [ Resend, as due to a cut and paste error, Ingo's and Andrew's email
>   was chopped off the Cc list ]
> 
> This includes minor updates to ftrace as well as the patchset
> for jump labels. I took out the debug printk patch that had caused
> earlier conflicts. We can add that one later.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 

Ping?

-- Steve


