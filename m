Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2GQTGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:06:41 -0400
Received: from 1wt.eu ([62.212.114.60]:4921 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab2GQTGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:06:38 -0400
Date: Tue, 17 Jul 2012 21:05:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: John Stultz <johnstul@us.ibm.com>
Cc: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.0-stable: Fix for leapsecond deadlock & hrtimer/futex issue
Message-ID: <20120717190553.GA4140@1wt.eu>
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com> <20120717175741.GA3665@1wt.eu> <5005ABC2.8050006@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5005ABC2.8050006@us.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 11:15:30AM -0700, John Stultz wrote:
> Attached are two tests. One is general exerciser of the leapsecond code 
> (leap-a-day) which also notes if it sees the hrtimer/futuex early 
> expiration issue, and the other is a much faster (almost immediate) 
> reproducer for the leapsecond deadlock (leapcrash).
> 
> The leapcrash test will likely wedge unpatched systems in hardirq 
> context, and has caused lost (dirty) data in my testing, so BEWARE!
> RUN AT YOUR OWN RISK!

Thank you, and nice note for the big warning above. I have some diskless
machines which don't risk anything, I will test there first :-)

Cheers,
Willy

