Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab0IPSsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:48:53 -0400
Received: from hemera.binary-island.eu ([97.107.138.233]:33015 "EHLO
	hemera.binary-island.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0IPSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:48:52 -0400
From: Matthias Dahl <ml_kernel@mortal-soul.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Improve latencies under load by decreasing minimum
Date: Thu, 16 Sep 2010 20:48:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        mathieu.desnoyers@efficios.com
MIME-Version: 1.0
Message-Id: <201009162048.50941.ml_kernel@mortal-soul.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I don't know if this is relevant but I just tried this ontop 2.6.35.4 while
investigating a different problem and it was quite easy to produce audio
buffer underruns while doing some compile job in the background.

To be exact: I had vlc (1.1 git) play back several flac files and was compiling
qt 4.7 in the background as a test w/ -j5 on an i7 860 . The result was that w/
the decreased granularity it caused noticeable audio buffer underruns while it
worked just fine w/ the default granularity (nothing else touched).

Just wanted to report this early on and hope it helps.

So long,
matthias.

PS. Please cc' as I am not subscribed. Thanks a lot.
