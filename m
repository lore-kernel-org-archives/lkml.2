Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1I1AJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:09:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:57221 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1I1AJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:09:25 -0400
Date: Wed, 28 Sep 2011 02:09:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
In-Reply-To: <1317076065.3112.539.camel@work-vm>
Message-ID: <alpine.LFD.2.02.1109280145150.2711@ionos>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>  <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011, John Stultz wrote:
> Another use case I've heard about are systems that have firmware updates

Yes, I have heard about people wanting O_PONIES ...

> that are remotely triggered. Should the system go into suspend while the
> firmware update is going on, you end up with a brick.

If someone came up with a firmware update mechanism which is not
coping with unexpected interruption of any kind, then wakelocks are
not making any difference.

Please collect the resulting bricks and shove them back to those who
thought that remote firmware updates do not have to be engineered and
the resulting fallout can be blamed on the kernel.

We have proper mechanisms in place to handle such stuff, but they need
proper overall design and definitely a bit more brain usage than just
yelling "wakelock".

Thanks,

	tglx
