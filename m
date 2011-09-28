Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1I1JRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:17:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33203 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1I1JRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:17:31 -0400
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
Date: Wed, 28 Sep 2011 11:16:39 +0200
In-Reply-To: <1317164216.3112.711.camel@work-vm>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317201399.18012.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> 
> 
> I do think my idea is neat, so we can spend/burn time debating it, but
> if you have viable suggestions (and honestly, I think rewriting all of
> userland isn't viable) on solving the larger problem, I'm all ears.
> 
And yet, rewriting all of userspace is exactly what Android did, they
had the perfect opportunity of doing it right, but they came up with the
worst solution ever.

As for my laptop, I really would like the firefox guys to add a
'feature' that stops JS on non-visible tabs and preferably also drop all
data after a little while.

firefox is the #1 wakeup thing on my machine and its mostly invisible
(minimized) and when its not, I can only stare at a single tab anyway.
