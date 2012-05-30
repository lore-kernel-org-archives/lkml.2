Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2E3PEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:04:35 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:56503 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751356Ab2E3PEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:04:33 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2012 11:04:33 EDT
Date: Wed, 30 May 2012 16:54:26 +0200 (CEST)
Message-Id: <20120530.165426.1421117300206344483.anders@netinsight.net>
To: dsmythies@telus.net
Cc: jrnieder@gmail.com, linux-kernel@vger.kernel.org,
        leslaw.kopec@nasza-klasa.pl, aman@tmm1.net, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
Subject: Re: [3.2.16 -> 3.2.17 regression] High reported CPU load when idle
From: Anders =?iso-8859-1?Q?Bostr=F6m?= <anders@netinsight.net>
In-Reply-To: <000c01cd3e70$b651dd10$22f59730$@net>
References: <20120523215359.GA19798@burratino>
	<20120524214516.GB1158@burratino>
	<000c01cd3e70$b651dd10$22f59730$@net>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "DS" == Doug Smythies <dsmythies@telus.net> writes:

 DS> This statement: "Starting with 3.2.17-1, the CPU load accounting is broken when the computer is idle. The CPU load is reported as >0.50 when idle. 3.2.16-1 don't suffer from this problem."
 DS> In my opinion has the following mistakes:
 DS> . The computer is not actually idle. If it was actually idle the reported load average would be 0.

Well, I tested in single user mode, with very few processes running,
mostly init, getty, bash and top (+ a lot of kernel threads). And
3.2.17 reported a load of >0.5 . Under the same conditions 3.2.16
typically reports 0.01 or 0.00 .

 DS> . Yes, the new kernel reported load average is high, as detailed in the PNG file or the web notes.
 DS> . The older kernel suffers from a different problem, under all other conditions being the same, the reported load average would have been too low.

I don't know if 0.01 is *too* low, but it should be much closer to the
truth than >0.5.

/ Anders
