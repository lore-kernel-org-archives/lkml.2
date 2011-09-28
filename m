Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1I1Gc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:32:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1I1Gcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:32:55 -0400
Date: Wed, 28 Sep 2011 08:31:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Could you reinstate ticketlock cleanups in tip.git
Message-ID: <20110928063115.GA24510@elte.hu>
References: <alpine.LFD.2.02.1109280209430.2711@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109280209430.2711@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Hi Thomas,
> 
> Could you reinstate the ticketlock cleanup series in tip.git (I think it
> was in x86/spinlocks) from
>     git://github.com/jsgf/linux-xen.git upstream/ticketlock-cleanup
> 
> This branch is the final result of all the discussions and revisions and
> is ready for the next merge window.  It's the one that's been in
> linux-next for a couple of weeks (at least), and won't cause any
> conflicts there.
> 
> Or if you prefer I can submit it myself for next merge window.
> 
> Thanks,
>     J

I'd prefer if this went via x86/spinlocks. Could you please send a 
proper pull request with diffstat, shortlog, etc?

Thanks,

	Ingo
