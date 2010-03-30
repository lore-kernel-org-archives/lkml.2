Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0C3AeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 20:34:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38281 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab0C3AeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 20:34:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: KVM bug, git bisected
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Kent Overstreet <kent.overstreet@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1269881082.12097.359.camel@laptop>
References: <1269880140.12097.356.camel@laptop> <1269881082.12097.359.camel@laptop>
Message-Id: <20100330093114.8E93.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Mar 2010 09:34:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2010-03-29 at 18:29 +0200, Peter Zijlstra wrote:
> 
> > > Peter, would it be safe to increase PREEMPT_BITS to eg. 10?
> 
> One reason this all sucks massive is that nesting that many spinlocks
> creates a terribly large !preempt section.
> 
> There is nothing that stops someone from creating 64k vmas (or more when
> someone raises that sysctl) and try this, that's just utter suckage.

offtopic: We are plan to increase default maximum vmas limit from 64k
at 1 or 2 years later on 64bit. It was necessary because gdb couldn't
parse >64k vmas (i.e. mainly it's for core dump). but it was solved already.



