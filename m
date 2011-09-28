Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1I1H6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:58:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35871 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1I1H6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:58:07 -0400
Date: Wed, 28 Sep 2011 09:57:52 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
Message-ID: <20110928075752.GA6670@netboy.at.omicron.at>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
 <1317068164.1763.39.camel@twins>
 <1317076065.3112.539.camel@work-vm>
 <1317119870.15383.29.camel@twins>
 <1317164216.3112.711.camel@work-vm>
 <1317196305.5781.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317196305.5781.5.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 09:51:45AM +0200, Peter Zijlstra wrote:
> SCHED_FIFO is an utter trainwreck, you're talking to the guy who gave a
> conference talk on why SCHED_FIFO sucks.

That sounds interesting. Do you have a link to the paper and/or
presentation?

Thanks,
Richard

