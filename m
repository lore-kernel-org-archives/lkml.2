Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0ESPMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:12:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61172 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab0ESPMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:12:39 -0400
X-Authority-Analysis: v=1.1 cv=APwCx09NCuKDvl2mjFwkKdJZScS8XOZHPgx3WG6BpL0= c=1 sm=0 a=8EtQVlZUVNwA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=XpggZ2iZSn5MWXWuHqgA:9 a=5mfSRkGfoaHztOheGyX0XS-IpHcA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Unexpected splice "always copy" behavior observed
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <alpine.LFD.2.00.1005190758070.23538@i5.linux-foundation.org>
References: <20100518153440.GB7748@Krystal>
	 <1274197993.26328.755.camel@gandalf.stny.rr.com>
	 <1274199039.26328.758.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org>
	 <20100519063116.GR2516@laptop>
	 <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org>
	 <1274280968.26328.774.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1005190758070.23538@i5.linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 19 May 2010 11:12:36 -0400
Message-ID: <1274281956.26328.776.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 07:59 -0700, Linus Torvalds wrote:
> 

> Btw, since you apparently have a real case - is the "splice to file" 
> always just an append? IOW, if I'm not right in assuming that the only 
> sane thing people would reasonable care about is "append to a file", then 
> holler now.

My use case is just to move the data from the ring buffer into a file
(or network) as fast as possible. It creates a new file and all
additions are "append to a file".

I believe Mathieu does the same.

With me, you are correct.

-- Steve


