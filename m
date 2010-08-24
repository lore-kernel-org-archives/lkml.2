Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0HXMkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:40:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:38249 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0HXMkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:40:31 -0400
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: balbir@linux.vnet.ibm.com, Venkatesh Pallipadi <venki@google.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <20100824140619.35850ae9@mschwide.boeblingen.de.ibm.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
	 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
	 <1282636286.2605.2307.camel@laptop>
	 <20100824080515.GK4684@balbir.in.ibm.com>
	 <1282640953.2605.2428.camel@laptop>
	 <20100824113801.GO4684@balbir.in.ibm.com>
	 <1282650835.2605.2629.camel@laptop>
	 <20100824140619.35850ae9@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 14:39:56 +0200
Message-ID: <1282653596.2605.2679.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 14:06 +0200, Martin Schwidefsky wrote:
> Well, I have sent a patch back in 2006 that stops adding the hardirq /
> softirq time to the currently running process. See
> http://lkml.org/lkml/2006/8/24/139

Time to maybe revisit that ;-)

> It did not get very far, so that answer to the question if we need
> accounting madness seems to be yes .. 

Well, that's only a little accounting, but trying to infer to what task
to account IRQ time is going to become madness.
