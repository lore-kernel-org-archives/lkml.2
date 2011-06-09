Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab1FIW7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:59:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35912 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1FIW7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:59:48 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 0/22]  0: Uprobes patchset with perf
 probe support
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 01:03:16 +0200
Message-ID: <1307660596.2497.1760.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
> Please do provide your valuable comments.

Your patch split-up is complete crap. I'm about to simply fold all of
them just to be able to read anything.

The split-up appears to do its best to make it absolutely impossible to
get a sane overview of things, tons of things are out of order, either
it relies on future patches filling out things or modifies stuff in
previous patches.

Its a complete pain to read..

