Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab2EIK6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:58:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:34611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab2EIK6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:58:06 -0400
Message-ID: <1336561050.2527.14.camel@twins>
Subject: Re: [PATCH v20] tracing: Fix kconfig warning due to a typo
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 09 May 2012 12:57:30 +0200
In-Reply-To: <4FAA06C8.6050700@hitachi.com>
References: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>
	  <1336476588.16236.20.camel@twins>
	  <1336481312.14207.164.camel@gandalf.stny.rr.com>
	 <1336483073.16236.37.camel@twins> <4FAA06C8.6050700@hitachi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 14:55 +0900, Masami Hiramatsu wrote:
> Would you mean SIB + displacement addressing? :)

Yeah something like that. Basically something that's powerful enough to
cover all things directly addressable by an architecture (for all
archs). So that if you put a probe at a specific location you can indeed
obtain all life variables at that spot.

This would include segment prefixes for x86 so we can get at per-cpu
variables.
