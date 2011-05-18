Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1ERQ3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:29:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1ERQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:29:00 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=TNYUVI2EnK0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=gu6fZOg2AAAA:8 a=LwH88lsQBqIQ9fhQ6xwA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 00/15] [GIT PULL] ftrace/recordmcount: cleanups and
 updates for recordmcount processing
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110518160809.724215604@goodmis.org>
References: <20110518160809.724215604@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 May 2011 12:28:57 -0400
Message-ID: <1305736137.11267.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 12:08 -0400, Steven Rostedt wrote:
> Ingo,
> 
> Please pull the latest tip/perf/core-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core-2
> 

Note, this is not based off of my tip/perf/core branch, but is based off
of tip separately.

I'm not sure why you don't want to pull my tip/perf/core directly yet.
I'd like to get that infrastructure in and tested before the 40 merge
window so that we can focus on the perf function tracing in the 41
window, and not try to figure out where bugs are between the two.

That pull request is here:

  http://marc.info/?l=linux-kernel&m=130469692420787

Thanks,

-- Steve


