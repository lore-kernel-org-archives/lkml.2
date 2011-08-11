Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1HKKqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:46:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:44438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1HKKqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:46:19 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 11 Aug 2011 12:45:58 +0200
References: <1312580681.28695.44.camel@twins>
	 <201108091713.19292.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313059558.23660.73.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 11:43 +0200, Peter Zijlstra wrote:
> 
> Right, so I wouldn't know where to start looking on this one. That's
> generic code exploding for some reason. How is that related to RTB and
> what is RTB to begin with?
> 
> 
Ah, ok so clue came late and PREEMPT_RTB is basically a half-way house
between PREEMPT and PREEMPT_RT (_FULL). It should build and boot but its
not actually meant to be used by anybody but the foolhardly developer.

Still no clue on how I wrecked things there though, maybe if I wake up
more..
