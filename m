Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0K3RAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:00:10 -0500
Received: from mailhost-y9-p4.netultra.net ([195.5.209.114]:63229 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751525Ab0K3RAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:00:08 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 12:00:08 EST
From: Damien Wyart <damien.wyart@free.fr>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tmhikaru@gmail.com, Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
References: <1288101958.15336.284.camel@twins>
	<1288381343.1988.12.camel@laptop>
	<20101109185516.GQ8332@bombadil.infradead.org>
	<1289329348.2191.69.camel@laptop>
	<20101110034507.GV8332@bombadil.infradead.org>
	<1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll>
	<20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop>
	<1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette>
	<1291030726.32004.4.camel@laptop>
Date: Tue, 30 Nov 2010 17:49:49 +0100
In-Reply-To: <1291030726.32004.4.camel@laptop> (Peter Zijlstra's message of
	"Mon, 29 Nov 2010 12:38:46 +0100")
Message-ID: <87bp56eoya.fsf@free.fr>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [101129 12:38]:
> > Doesn't give wrong numbers like initial bug and tentative patches, but
> > feels a bit too slow when numbers go up and down. Correct values are
> > reached when waiting long enough, but it feels slow.

> > As I've tested many combinations, maybe this is an impression because
> > I do not remember about "normal" delays for the load to rise and fall,
> > but this still feels slow.

> You can test this by either booting with nohz=off, or builting with
> CONFIG_NO_HZ=n and then comparing the result, something like

> make O=defconfig clean; while sleep 10; do uptime >> load.log; done &
> make -j32 O=defconfig; kill %1

> And comparing the curves between the NO_HZ and !NO_HZ kernels.

In fact, timings were very similar between the two configurations, so
I guess my feelings were wrong... They were also similar with the next
version of the patch.

-- 
Damien Wyart
