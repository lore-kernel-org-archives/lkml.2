Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0KRHEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:04:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0KRHEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:04:52 -0500
Subject: Re: [ANNOUNCE v2] ktest.pl: Easy and flexible testing script for
 Linux Kernel Developers (now with config bisect)
From: Jon Masters <jcm@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, lmr@redhat.com,
        Greg Kroah-Hartman <gregkh@suse.de>, autotest@test.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <1289259910.12418.77.camel@gandalf.stny.rr.com>
References: <1289259910.12418.77.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat, Inc.
Date: Thu, 18 Nov 2010 02:03:05 -0500
Message-ID: <1290063785.3916.1124.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 18:45 -0500, Steven Rostedt wrote:

> It compiles, and performs the type of test specified by the
> CONFIG_BISECT_TYPE option (build, boot or test). If it passes, then all
> the configs that were enabled in the .config are removed from the
> configs to test and added to the good configs to always enable. This
> allows for configs in the other half to be enabled if they depended on
> these configs.

Haven't had time to play, but I was thinking about this when bisecting
an i915 bug last week. In that case none of the kernels failed to boot,
they just had busted modelines. Do you have support in this tool for
testing some condition on the system after it boots? I would guess I
probably would have needed something more heavyweight (that could run a
script to look for busted modes on the target after booting).

Jon.


