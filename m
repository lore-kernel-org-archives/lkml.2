Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0ERP60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:58:26 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:39313 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab0ERP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:58:25 -0400
Date: Tue, 18 May 2010 10:56:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Nick Piggin <npiggin@suse.de>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unexpected splice "always copy" behavior observed
In-Reply-To: <20100518155135.GJ2516@laptop>
Message-ID: <alpine.DEB.2.00.1005181055260.16649@router.home>
References: <20100518153440.GB7748@Krystal> <20100518155135.GJ2516@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Nick Piggin wrote:

> What would be needed is to have filesystem maintainers go through and
> enable it on a case by case basis. It's trivial for tmpfs/ramfs type
> filesystems and I have a patch for those, but I never posted it on.yet.
> Even basic buffer head filesystems IIRC get a little more complex --
> but we may get some milage just out of invalidating the existing
> pagecache rather than getting fancy and trying to move buffers over
> to the new page.

There is a "migration" address space operation for moving pages. Page
migration requires that in order to be able to move dirty pages. Can
splice use that?


