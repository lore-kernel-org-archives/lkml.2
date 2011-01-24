Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1AXT4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:56:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab1AXT43 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:56:29 -0500
MIME-Version: 1.0
In-Reply-To: <20110124133400.GA1228@elte.hu>
References: <20110124133400.GA1228@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Jan 2011 05:48:01 +1000
Message-ID: <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 11:34 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest perf-fixes-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

I'm not sure if this was true before too, but when I do

    perf report -agf sleep 10

while compiling the kernel to get a system profile on x86-32, the
resulting pef.data file will cause "perf report" to just hang.

Is it just me?

                Linus
