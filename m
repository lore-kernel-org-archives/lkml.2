Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab2EJLsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:48:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40170 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2EJLsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:48:06 -0400
X-AuditID: b753bd60-a2688ba000000655-9a-4fabaaf29305
X-AuditID: b753bd60-a2688ba000000655-9a-4fabaaf29305
Message-ID: <4FABAAE9.6040701@hitachi.com>
Date: Thu, 10 May 2012 20:47:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: Re: [PATCH v20] tracing: Fix kconfig warning due to a typo
References: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>   <1336476588.16236.20.camel@twins>   <1336481312.14207.164.camel@gandalf.stny.rr.com>  <1336483073.16236.37.camel@twins> <4FAA06C8.6050700@hitachi.com> <1336561050.2527.14.camel@twins>
In-Reply-To: <1336561050.2527.14.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/09 19:57), Peter Zijlstra wrote:
> On Wed, 2012-05-09 at 14:55 +0900, Masami Hiramatsu wrote:
>> Would you mean SIB + displacement addressing? :)
> 
> Yeah something like that. Basically something that's powerful enough to
> cover all things directly addressable by an architecture (for all
> archs). So that if you put a probe at a specific location you can indeed
> obtain all life variables at that spot.
> 
> This would include segment prefixes for x86 so we can get at per-cpu
> variables.

Ah, right. Hmm, the problem is that this interface's syntax should be
arch-independent. It need to be extended to support more complex
addressing mode.

Thank you for the request!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
