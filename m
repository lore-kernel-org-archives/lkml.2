Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0K1Lkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 06:40:52 -0500
Received: from mailhost-p4-m2.nerim.net ([78.40.49.191]:53123 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752358Ab0K1Lkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 06:40:51 -0500
Date: Sun, 28 Nov 2010 12:40:27 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tmhikaru@gmail.com, Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101128114027.GA2745@brouette>
References: <1288101958.15336.284.camel@twins>
 <1288381343.1988.12.camel@laptop>
 <20101109185516.GQ8332@bombadil.infradead.org>
 <1289329348.2191.69.camel@laptop>
 <20101110034507.GV8332@bombadil.infradead.org>
 <1289390424.2191.98.camel@laptop>
 <20101114051406.GA2050@roll>
 <20101125133106.GA12914@brouette>
 <1290693807.2145.36.camel@laptop>
 <1290888920.32004.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290888920.32004.1.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Peter Zijlstra <peterz@infradead.org> [2010-11-27 21:15]:
> How does this work for you? Its hideous but lets start simple.
> [...]

Doesn't give wrong numbers like initial bug and tentative patches, but
feels a bit too slow when numbers go up and down. Correct values are
reached when waiting long enough, but it feels slow.

As I've tested many combinations, maybe this is an impression because
I do not remember about "normal" delays for the load to rise and fall,
but this still feels slow.

Thanks for working on this problem again.

-- 
Damien Wyart
