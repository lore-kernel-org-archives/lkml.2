Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1I1Hwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:52:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:42037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1I1Hwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:52:43 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 28 Sep 2011 09:51:45 +0200
In-Reply-To: <1317164216.3112.711.camel@work-vm>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317196305.5781.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> Sure, and real-time tasks should coordinate with all of userland to just
> make sure no one gets in the way! And those applications should respect
> that! Why is all that *useless* code in the kernel!? :) 

In fact they should, its impossible to develop two sets of real-time
applications and shove them on the same box without co-ordination.

SCHED_FIFO is an utter trainwreck, you're talking to the guy who gave a
conference talk on why SCHED_FIFO sucks.

The only reason we have SCHED_FIFO is because of POSIX, and its one of
those things where they fucked up worse than usual (mostly because
people often don't realize how broken it is).



