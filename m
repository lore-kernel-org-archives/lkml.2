Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab0DYOfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 10:35:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0DYOfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 10:35:39 -0400
Subject: Re: Q: sched_clock() vs. clocksource, how to implement correctly
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Magnus Damm <damm@opensource.se>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100424205011.GA21632@sig21.net>
References: <20100423150917.GA25714@sig21.net>
	 <20100423182933.0df45b53@mschwide.boeblingen.de.ibm.com>
	 <20100424205011.GA21632@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 25 Apr 2010 16:36:14 +0200
Message-ID: <1272206174.5289.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-24 at 22:50 +0200, Johannes Stezenbach wrote:
> Somehow I got the impression that cnt32_to_63() is old-style,

Not really, the biggest problem it has is that is not SMP aware. I did
some patches for that at one time, but people objected for some reason.
