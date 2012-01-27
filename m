Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab2A0LZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:25:01 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37701 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386Ab2A0LZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:25:00 -0500
Date: Fri, 27 Jan 2012 11:24:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Greg KH <greg@kroah.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Long term stable kernel seletion (3.0)
Message-ID: <20120127112434.GA7757@arm.com>
References: <CAJ8eaTwfYvAEUXX=LMFfHvvyG1JKT4wADqofb0YdyaUtDT8GEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8eaTwfYvAEUXX=LMFfHvvyG1JKT4wADqofb0YdyaUtDT8GEg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 05:24:42AM +0000, naveen yadav wrote:
> Recently Greg decide and select linux 3.0 for long term.
> 
> http://www.kroah.com/log/
> 3.0.y - this is the new "longterm" kernel release, it will be
> maintained for 2 years at the minimum by me.
> 
> PS. Catalin+ Greg
> So I have one request from Mr. Catalin and Greg.
> 
> Is ARM-15 support will be added in this or not. ?

It depends on how much Cortex-A15 support you mean. UP with classic MMU
is already supported as it's an ARMv7 processor. SMP with classic MMU
got merged in 3.1-rc1 (commit 7665d9d2df - "ARM: proc: add proc info for
Cortex-A15MP using classic page tables"). ARM LPAE was merged in 3.3-rc1
and generic timers probably during the next merging window.

ARM LPAE and generic timers are unlikely to be back-ported to 3.0
(though I have some patches around but they need considerable amount of
timer for maintaining in a long-term release).

-- 
Catalin
