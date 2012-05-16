Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab2EPTge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:36:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:64566 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760543Ab2EPTgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:36:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144838873"
Message-ID: <4FB401B2.1010906@linux.intel.com>
Date: Wed, 16 May 2012 12:36:18 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracing: Remove useless 4 bytes of padding from
 every event
References: <1337175871.6724.46.camel@gandalf.stny.rr.com> <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
In-Reply-To: <CA+55aFzVngkixn-t0mK8QqgnPhCzN2AsUtzfZ3BkLiJAcjNOzQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/2012 12:33 PM, Linus Torvalds wrote:
> On Wed, May 16, 2012 at 6:44 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> But this change will break PowerTop v1. Thus my question is, how long do
>> we need to keep this wasted space in the ring buffers to satisfy an out
>> of date tool?
> 
> The wasted space seems of limited importance.
> 
> More important is to check which distros have the new powertop.
> 
> F16 and F17 seem to have powertop-1.98, which I assume is the new
> world order already. But maybe I assume incorrectly.

this is the one that will break

> 
> F14 (which I personally still use, since it doesn't have gnome3) is 1.13.

this one is fine, it does not use perf events at all.

