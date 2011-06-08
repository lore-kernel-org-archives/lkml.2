Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1FHHGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1FHHGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:06:13 -0400
Message-ID: <4DEF1F07.4000400@redhat.com>
Date: Wed, 08 Jun 2011 00:04:39 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Wilson <wilsons@start.ca>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 3/22]  3: uprobes: Adding and remove a
 uprobe in a rb tree.
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <20110607125850.28590.10861.sendpatchset@localhost6.localdomain6> <20110608041217.GA4879@wicker.gateway.2wire.net>
In-Reply-To: <20110608041217.GA4879@wicker.gateway.2wire.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 09:12 PM, Stephen Wilson wrote:
> Also, changing the argument order seems to solve the issue reported by
> Josh Stone where only the uprobe with the lowest address was responding
> (thou I did not test with perf, just lightly with the trace_event
> interface).

Makes sense, and indeed after swapping the arguments to both calls, the
perf test I gave now works as expected.  Thanks!

Josh
