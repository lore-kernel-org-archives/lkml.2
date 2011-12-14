Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1LNAM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:12:26 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40406 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab1LNAMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:12:25 -0500
Date: Tue, 13 Dec 2011 19:12:21 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: Chris Palmer <chris.palmer@pobox.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [PROBLEM] ASUS Sandybridge motherboards + PCI not
 working (IRQ n: nobody cared)
Message-ID: <20111214001221.GA2143@Brahman>
References: <CADLC3L3wZuS-1oNoOkkU5uEDhmUio3edL05Cy4EDapfG-Y202w@mail.gmail.com>
 <4EE72C4D.9080207@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE72C4D.9080207@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris -

[Dammit, accidentally sent an html mail.  Should have stepped out of gmail,
sorry.]

I will certainly take a look.  I don't have the hardware, unfortunately.  And
this is kinda my first rodeo, kernel-wise, so don't let me sound too expert. :)
Let me ask a couple questions, anyway.

- Later, I'll have time to look for Andrew's message, but do you know -- did he
  mean an ACPI bug in the firmware, or in Linux?

- Does 2.6.38 behave the same as 3.1.5 or the other newest kernels?  (If the
  hardware doesn't require something newer than .38.)  There was an IRQ overhaul
  in 2.6.39, and the two bugs I fixed were regressions from that work.  As of
  now, the bad-irq handling seems equivalent to 2.6.38, but I should make sure
  that goes for your problem, too.

I think I'll cc LKML, too, if you don't mind.  I've seen this topic going by,
but don't know what's been said.  And maybe tomorrow I can get some pondering
time -

Ed

