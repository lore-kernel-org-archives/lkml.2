Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2EZPIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 11:08:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57811 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2EZPIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 11:08:17 -0400
Date: Sat, 26 May 2012 17:07:51 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai
 threshold
Message-ID: <20120526150750.GA28116@netboy.at.omicron.at>
References: <4FBA84EF.5040506@linaro.org>
 <20120521190815.GA19812@netboy.at.omicron.at>
 <20120522173953.GA4177@netboy.at.omicron.at>
 <4FBBD591.1000103@linaro.org>
 <20120523082916.GA15627@localhost.localdomain>
 <4FBD1545.4070408@linaro.org>
 <20120523191747.GA2348@netboy.at.omicron.at>
 <4FBD4613.7040003@linaro.org>
 <20120524064340.GA2180@netboy.at.omicron.at>
 <20120524065726.GB2180@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524065726.GB2180@netboy.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 08:57:28AM +0200, Richard Cochran wrote:
> On Thu, May 24, 2012 at 08:43:40AM +0200, Richard Cochran wrote:
> > BTW you can use the program I have been using to test this at
> > 
> >    git://github.com/richardcochran/leap.git
> 
> That program exposes another leap second bug, too, I think. It reads
> the time via adjtimex in a tight loop, optionally sleeping using
> 
> 	clock_nanosleep(CLOCK_MONOTONIC, 0, &ts, NULL);
> 
> The program does not wake from this call during a leap second. It is
> my expectation that CLOCK_MONOTONIC should always work. Why doesn't
> it?

FWIW, the V1 of this patch series fixes this problem, but V2 doesn't.

Maybe that fact promotes my original idea?

Thanks,
Richard
