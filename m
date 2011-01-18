Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1ARQRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:17:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab1ARQRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:17:40 -0500
Date: Tue, 18 Jan 2011 17:09:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 0/2] perf: event->cpu checking fixes
Message-ID: <20110118160942.GA693@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20110117203459.GA32700@redhat.com> <1295297576.30950.382.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295297576.30950.382.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Peter Zijlstra wrote:
>
> Wasn't this sorted by: 8882135bcd332f294df5455747ea43ba9e6f77ad?

No. This commit only answers my 3rd question, 1-2 are still waiting ;)

> > I am reading perf_event.c, but all I found so far is a couple of trivial
> > methods to crash the kernel via sys_perf_event_open(), will report
> > tomorrow...
>
> Ow, that's not too pretty..

Fortunately, this is trivial. Probably 2.6.37 needs these fixes too.

Oleg.

