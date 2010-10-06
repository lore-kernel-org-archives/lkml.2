Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab0JFSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:09:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759532Ab0JFSJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:09:58 -0400
MIME-Version: 1.0
In-Reply-To: <20101006175635.GA21652@Krystal>
References: <20101006175635.GA21652@Krystal>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Oct 2010 11:08:32 -0700
Message-ID: <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com>
Subject: Re: [RFC PATCH] poll(): add poll_wait_set_exclusive()
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 10:56 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> Executive summary:
>
> Addition of the new internal API:

Executive summary: no.

You need to explain first how you could _ever_ use this without
breaking select/poll semantics totally.

IOW, you need to explain the user space interface first. Before you do
that, this patch is total and utter crap that is expressly designed to
used only in a manner that is a pure bug.

                       Linus
