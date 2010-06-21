Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0FUOUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:20:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab0FUOUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:20:19 -0400
X-Authority-Analysis: v=1.1 cv=zLGBfXKW/yOQN1c4qTdQUWouaSiWOaUUjRgOJi1LSJI= c=1 sm=0 a=cXXvhkFfZJUA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=Je9ypJdxDb0MDSoXatsA:9 a=tXD-XgEzZdSFsBSj61OcuJ0fctUA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v5 3/14] User Space Breakpoint Assistance Layer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100614174030.GB23754@infradead.org>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
	 <20100614082832.29068.53628.sendpatchset@localhost6.localdomain6>
	 <20100614174030.GB23754@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Jun 2010 10:20:16 -0400
Message-ID: <1277130016.9181.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 13:40 -0400, Christoph Hellwig wrote:
> On Mon, Jun 14, 2010 at 01:58:32PM +0530, Srikar Dronamraju wrote:
> > User Space Breakpoint Assistance Layer (USER_BKPT)
> > Changelog from V3: (reimplement background page replacement)
> > 	* Replemented background page replacement based on inputs
> > 	  from Peter Zijlstra.
> > 
> > Changelog from v2: (addressing comments from Oleg)
> 
> FYI the changelog should be under the --- marker so that it doesn't
> get included into the final commit message.
> 

Actually, I find the version'ing of a patch in the changelog useful. It
gives a bit of history to how the patch was created.

-- Steve


