Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab0KOKuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:50:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60409 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab0KOKug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:50:36 -0500
Subject: Re: [PATCH] clocksource: document some basic concepts
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nico@fluxnic.net>, Colin Cross <ccross@google.com>,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
In-Reply-To: <1289818094.2109.487.camel@laptop>
References: <1289817228-14838-1-git-send-email-linus.walleij@stericsson.com>
	 <1289818094.2109.487.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 11:50:43 +0100
Message-ID: <1289818243.2109.488.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 11:48 +0100, Peter Zijlstra wrote:
> 
> Therefore, sched_clock() shall not be used, see kernel/sched_clock.c for
> detail and alternative interfaces. 

we should probably rename the thing to __arch_sched_clock() and migrate
people to the kernel/sched_clock.c interfaces.
