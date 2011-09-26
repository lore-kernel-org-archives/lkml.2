Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab1IZODP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:03:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46592 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1IZODN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:03:13 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 12/26]   Uprobes: Handle breakpoint and
 Singlestep
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 26 Sep 2011 16:02:25 +0200
In-Reply-To: <20110920120221.25326.74714.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
	 <20110920120221.25326.74714.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317045745.1763.25.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 17:32 +0530, Srikar Dronamraju wrote:
> + * Guarded by uproc->mutex.

That seems to be the only reference to this thing here... what's a uproc
and where's this mutex?
