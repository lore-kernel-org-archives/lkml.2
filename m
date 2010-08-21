Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab0HUS0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 14:26:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61231 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0HUS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 14:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sXTpPErjRw3eDYlp/KPXZa1pTuqnzx1cEp0jZrUo7chfkmG0/8PjcXHdQ0Xvle3vGh
         maVAah23uHVoSE6rgE3aC+V/a5xvX/eDzP8pFkp3IyS7ZnjLFx3DNSDkZfRNvTSSvolE
         o5VDvLA8zgOw6p+239icfrJNdbJ/URSxZytrM=
Date: Sat, 21 Aug 2010 21:26:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Imre Deak <imre.deak@nokia.com>,
        Jamie Lokier <jamie@shareable.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH for -tip 1/2] kernel.h: add
 MAYBE_BUILD_BUG_ON_NOT_POWER_OF_2
Message-ID: <20100821182623.GA9621@core2.telecom.by>
References: <20100821141750.770348530@efficios.com>
 <20100821142215.023431313@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821142215.023431313@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 10:17:51AM -0400, Mathieu Desnoyers wrote:
> +/* Force a compilation error if condition is constant and not a power of 2 */
> +#define MAYBE_BUILD_BUG_ON_NOT_POWER_OF_2(n)		\
> +	MAYBE_BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))

Sorry, this is tasteless macro.
