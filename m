Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2IVPpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 11:45:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38553 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2IVPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 11:45:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120921220302.GF2454@linux.vnet.ibm.com>
References: <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
	<F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com>
	<20120920220130.GN2449@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
	<20120920232114.GO2449@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
	<20120921185827.GC2454@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
	<20120921195717.GD2454@linux.vnet.ibm.com>
	<20120921203149.GI28835@atomide.com>
	<20120921220302.GF2454@linux.vnet.ibm.com>
Date: Sat, 22 Sep 2012 17:45:12 +0200
Message-ID: <CAFTL4hy5wO9CL5_1e8U7L3Tihm_HYD6uAsda3ue-zDKFjir2Xg@mail.gmail.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/22 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Fri, Sep 21, 2012 at 01:31:49PM -0700, Tony Lindgren wrote:
>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [120921 12:58]:
>> >
>> > Just to make sure I understand the combinations:
>> >
>> > o   All stalls have happened when running a minimal userspace.
>> > o   CONFIG_NO_HZ=n suppresses the stalls.
>> > o   CONFIG_RCU_FAST_NO_HZ (which depends on CONFIG_NO_HZ=y) has
>> >     no observable effect on the stalls.
>>
>> The reason why you may need minimal userspace is to cut down
>> the number of timers waking up the system with NO_HZ.
>> Booting with init=/bin/sh might also do the trick for that.
>
> Good point!  This does make for a very quiet system, but does not
> reproduce the problem under kvm, even after waiting for four minutes.
> I will leave it for more time, but it looks like I really might need to
> ask Linaro for remote access to a Panda.

I have one. I'm currently installing Ubuntu on it and I'll try to
manage to build
a kernel and reproduce the issue.

I'll give more news soon.
