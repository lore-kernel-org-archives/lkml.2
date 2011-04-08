Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1DHI2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:28:36 -0400
Received: from mx1.orcon.net.nz ([219.88.242.51]:39940 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab1DHI2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:28:34 -0400
Message-ID: <4D9EC730.2090105@orcon.net.nz>
Date: Fri, 08 Apr 2011 20:28:32 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Linux 2.6.39-rc2 doesn't boot on alpha.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx1.orcon.net.nz on Fri, 08 Apr 2011 20:28:33 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Apr  8 20:28:33 2011
X-DSPAM-Confidence: 0.5682
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resent with correction to linux-alpha email list]

Linux 2.6.39-rc[12] doesn't boot at all on Alpha.  As soon as the kernel 
has loaded the system freezes.

Bisection gave the following as the first bad commit:

commit 091738a266fc74329ae186f22ff2b3f01319112d genirq: Remove real old 
transition functions

If I reverse (as far as possible) the second half of the commit (the bit 
that applies to kernel/irq/chip.c) from 2.6.39-rc2 then I get a kernel 
that starts booting but freezes when it prints "Calibrating delay loop..."

Cheers
Michael.
