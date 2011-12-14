Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1LNHVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:21:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40846 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1LNHVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:21:02 -0500
Date: Wed, 14 Dec 2011 08:20:58 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20111214072058.GA2180@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
 <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323747782.4078.144.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 07:43:02PM -0800, john stultz wrote:
> 
> Having a CLOCK_TAI would be interesting across the board. We already
> keep a TAI offset in the ntp code. However, I'm not sure if ntp actually
> sets it these days.

A bit OT, but what do think of the idea of keeping TAI in the kernel,
and providing UTC via a tabular conversion routine?

Michel Hack wrote an article last year detailing how Linux botches the
leap second and suggested a more robust way to handle it.

Thanks,
Richard


