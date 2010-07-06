Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0GFQpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:45:49 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:44312 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab0GFQpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:45:41 -0400
Date: Wed, 7 Jul 2010 01:45:39 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: high power consumption in recent kernels
Message-ID: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please CC)

it seems that some of the (?)recent(?) changes have increased the
power consumption of my note book considerably.

First of all, running powertop with normal programs started, but 
doing nothing, I am still at 14W while I could go down to 9W before
(but the 9W was with dimmed display).

In the list of top causes for wakeup I have
Top causes for wakeups:
  34.2% (185.3)   [kernel scheduler] Load balancing tick
  23.9% (129.6)   [extra timer interrupt]
  10.8% ( 58.6)   firefox-bin
   9.2% ( 49.7)   [iwlagn] <interrupt>
   7.2% ( 39.1)   [kernel core] hrtimer_start (tick_sched_timer)
   3.9% ( 20.9)   PS/2 keyboard/mouse/touchpad interrupt
which show one new thing to me I haven't seen before, the Loa balancing tick.

Furthermore, I also had the feeling that while being suspend to RAM 
the battery is also emptied faster then before, but by now I have not
concise data points for that.

I am running the latest kernel pulled from git.kernel.org, linux-2.6.

I have seen some patches from Venkatesh Pallipadi dealing twith this 
issue (http://lkml.org/lkml/2010/6/9/109) but it does not apply to
the current kernel sources at all.

Please let me know if you have any suggestions of if I should test
something.

Thanks and all the best

Norbert

Please CC
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HARBOTTLE (n.)
A particular kind of fly which lives inside double glazing.
			--- Douglas Adams, The Meaning of Liff
