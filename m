Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab1JEHEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:04:09 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:45682 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1JEHEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:04:07 -0400
Message-Id: <6.2.5.6.2.20111005025227.03a9d9f0@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Wed, 05 Oct 2011 02:58:17 -0400
To: Joe Perches <joe@perches.com>, Christoph Lameter <cl@gentwo.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Con Kolivas <kernel@kolivas.org>
From: starlight@binnacle.cx
Subject: Re: big picture UDP/IP performance question re 2.6.18
  -> 2.6.32
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Final note:

I had captured latency measurements for
two of the three kernels.  Just ran
2.6.18(rhel5) and the results are
stunning.  The older kernel is much,
much better then the newer kernel.

Average latency is three times better
and the standard deviation is six
time better.  As in 300% and 600%.

Latency here is the time it takes
a packet to travel from the kernel
(where it is timestamped) till it
reaches the final consumption point
in the application.

Makes me think that the old kernel
is better at keeping caches hot and
scheduling woken threads on the same
cores as the threads that triggered
them.

