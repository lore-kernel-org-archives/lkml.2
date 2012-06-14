Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2FNJZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:25:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44800 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab2FNJZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:25:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120613152045.81ab66d9.akpm@linux-foundation.org>
References: <CAJRGBZw2TctmBxRuA-byaGNCs=1v+M-1PXSm+OuwWApSqu7UjA@mail.gmail.com>
	<20120613152045.81ab66d9.akpm@linux-foundation.org>
Date: Thu, 14 Jun 2012 05:25:44 -0400
Message-ID: <CAJRGBZy_wqUgN_jx9PinXHSGM30XjrRm49xFXkfumucAeaQ2bw@mail.gmail.com>
Subject: Re: What is the right practice to get new code upstream( was Fwd:
 [patch] a simple hardware detector for latency as well as throughput ver. 0.1.0)
From: Luming Yu <luming.yu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        sfr@canb.auug.org.au, jcm@jonmasters.org, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 6:20 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 12 Jun 2012 20:57:02 +0800
> Luming Yu <luming.yu@gmail.com> wrote:
>
>> I need to know what the right practice is to get your attention to
>> accept a new tool upstream like this one.
>
> Seems that you have some good feedback from Arnd to be looking at.  I'm
> usually the guy for mysterious misc stuff such as this, so please cc me
> on future revisions.

Andrew, Thanks a lot :-) The community is really helpful after find
right people for right things.

>
> The name "hw_test" and "HW_TEST" is too vague.  The topic "testing
> hardware" is very broad, and this module only touches a small fraction
> of it, so please think up a far more specific name.
>

I'm working on Version 2 of the tool which would be renamed to
cpu_latency_test, or simply misc_latency_test?

thanks!!! /l
