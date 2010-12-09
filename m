Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0LIFyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 00:54:55 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40799 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0LIFyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 00:54:54 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/9] perf: Consolidate the event handling and ordering
From: Ian Munsie <imunsie@au1.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-reply-to: <20101208202452.GA14237@ghostprotocols.net>
References: <20101207124527.868085529@linutronix.de> <20101208202452.GA14237@ghostprotocols.net>
Date: Thu, 09 Dec 2010 16:54:44 +1100
Message-Id: <1291873283-sup-9561@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Arnaldo Carvalho de Melo's message of Thu Dec 09 07:24:52 +1100 2010:
> Hi Ian,
> 
>     Have you had the chance of reviewing/testing this patch series
> so that we know that your needs are satisfied with it?

Hi Arnaldo,

Sorry I didn't get around to reviewing them yesterday. Overall they look
pretty good, other than the fall back issue running them the userspace
tool on an unpatched kernel I mentioned.

I've added my patch to enable the sorting in perf record. This time I
also enabled it in perf annotate and perf diff as I realised they would
also need the ordering to properly attribute the samples. I haven't
added it to any other commands - some already enable ordered_samples, so
we wouldn't want to enable ordering_requires_timestamps on them, and I
don't think any of the remaining commands need it.

Cheers,
-Ian
