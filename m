Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1HXQ4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:56:43 -0400
Received: from mail-pz0-f70.google.com ([209.85.210.70]:43802 "EHLO
	mail-pz0-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1HXQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:56:41 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Aug 2011 12:56:41 EDT
MIME-Version: 1.0
In-Reply-To: <1314188833.6925.3.camel@twins>
References: <1314188833.6925.3.camel@twins>
Date: Wed, 24 Aug 2011 09:51:28 -0700
Message-ID: <CABQzsv_8mOH3LJa=vSW6F56V2CtxMwp8+3OX1ns=nEiW3P=QaA@mail.gmail.com>
Subject: Re: [ia64] Question on __ARCH_WANT_UNLOCKED_CTXSW
From: Ken Chen <kenchen@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Luck,Tony" <tony.luck@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 5:27 AM, Peter Zijlstra wrote:
> Ken, Tony,
>
> happen to remember what the perceived benefit of using
> __ARCH_WANT_UNLOCKED_CTXSW was about?

Boy, this was so long ago and my memory is fading.  Low level ia64 arch
has lengthy context switch path in assembly code due to large CPU register
file, IIRC __ARCH_WANT_UNLOCKED_CTXSW gave lower runqueue lock contention
for workloads that was heavy in wakeup and ctx switch events (I remember it
was particularly useful on large smp machine that has hundreds of CPUs).
I don't know whether the situation still applies today when scheduler code
evolved quite a bit over past 5 years.  I think the needs for ia64 require
a fresh re-evaluation.

- Ken
