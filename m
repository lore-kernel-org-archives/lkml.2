Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0IMSKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:10:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46798 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab0IMSKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:10:21 -0400
X-Authority-Analysis: v=1.1 cv=FR6uSFBUsHpo/LPxUdUfz19YCIdHKFi4UJmy4GdSgrg= c=1 sm=0 a=C5GAk3d9sJMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=acTSpjNFmA1aC5MhuBEA:9 a=zJSv8j6i-uy-MZgobbumD6by1agA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime
 with wall time
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <AANLkTi=8m4g01wZPacySoF7U0PevTNVgJoZZrHiUD-pN@mail.gmail.com>
References: <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop>
	 <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal>
	 <1284387398.2275.311.camel@laptop> <20100913161641.GA28707@Krystal>
	 <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
	 <20100913174533.GA15653@Krystal>
	 <AANLkTi=8m4g01wZPacySoF7U0PevTNVgJoZZrHiUD-pN@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Sep 2010 14:10:18 -0400
Message-ID: <1284401418.17152.81.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 10:51 -0700, Linus Torvalds wrote:

> I'll test that myself (but in a bit - I need to go do voter
> registration and socsec update first, though - I became a US citizen
> last week).

Congrats!

-- Steve


