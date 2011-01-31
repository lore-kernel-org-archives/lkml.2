Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1AaJam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 04:30:42 -0500
Received: from www.tglx.de ([62.245.132.106]:59995 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab1AaJal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 04:30:41 -0500
Date: Mon, 31 Jan 2011 10:29:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V10 00/15] ptp: IEEE 1588 hardware clock support
In-Reply-To: <cover.1296124770.git.richard.cochran@omicron.at>
Message-ID: <alpine.LFD.2.00.1101311026010.31804@localhost6.localdomain6>
References: <cover.1296124770.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Richard Cochran wrote:

> Here is version 10 of the PHC patch series. We missed the boat for
> 2.6.38, but I hope this can be merged for the next one.
> 
> Reviewers: I think its done. How can I get this merged?

Looks pretty good. I go through the patches again and I'd like to have
a ack/reviewed by from John. The whole thing can go through
tip/timers.
 
> Arch maintainers (arm, blackfin, powerpc, x86): I have added you on
> CC in the hope of getting your acks for the new syscall.

I'll take the x86 one right away. For the other archs we can apply
those patches via the arch trees even during the merge window.

Thanks,

	tglx
