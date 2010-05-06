Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab0EFUWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:22:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab0EFUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:22:44 -0400
Subject: Re: [BUG] perf_events: PERF_FORMAT_GROUP not working correctly
 when monitoring another task
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Carl Love <carll@us.ibm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       stephane eranian <eranian@googlemail.com>
In-Reply-To: <4BE321F8.1050309@linux.vnet.ibm.com>
References: <4BDF8118.3090200@linux.vnet.ibm.com>
	 <1273160566.5605.404.camel@twins>  <4BE321F8.1050309@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 22:22:40 +0200
Message-ID: <1273177360.1642.280.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 13:09 -0700, Corey Ashford wrote:
> The patch works with the test case I provided, but for some reason it 
> breaks the normal operation of the libpfm4 "task" utility.  If I put 
> more than one event in a group, I get zero counts on all but the first 
> event.  That's even if I don't use the PERF_FORMAT_GROUP option.

Bugger,.. weird though, I can't see how it would affect the state before
the counters get detached from their context (exit() / close()).

> So something appears to be messed up.  I will see if I can construct an 
> arch-independent test case which demonstrates the problem.

That would be awesome, thanks!


