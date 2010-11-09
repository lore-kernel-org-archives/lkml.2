Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0KIQZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:25:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab0KIQZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:25:00 -0500
Date: Tue, 9 Nov 2010 17:18:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && event->owner
Message-ID: <20101109161827.GB1903@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere> <1289248872.2191.27.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289248872.2191.27.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Peter Zijlstra wrote:
>
> As to removing event->owner as Oleg suggests, its a published ABI and
> there might be people using it.

This was my main question.

It's a pity ;) This ABI doesn't look very nice, but OK.

Oleg.

