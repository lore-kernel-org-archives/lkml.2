Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1JYXb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 19:31:29 -0400
Received: from 1wt.eu ([62.212.114.60]:34486 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab1JYXb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 19:31:28 -0400
Date: Wed, 26 Oct 2011 01:25:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: john stultz <johnstul@us.ibm.com>
Cc: Ruben Kerkhof <ruben@rubenkerkhof.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
        Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es, Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20111025232545.GB14714@1wt.eu>
References: <20110721072256.GE9216@elte.hu> <1311251098.29152.130.camel@twins> <20110721125008.GF11246@pcnci.linuxbox.cz> <1311252799.29152.147.camel@twins> <20110721184524.GB381@elte.hu> <20110825185616.GA17078@faidon.noc.grnet.gr> <20110830223829.GB17450@kroah.com> <20110904232657.GC6749@tty.gr> <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com> <1319582670.17505.31.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319582670.17505.31.camel@work-vm>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Tue, Oct 25, 2011 at 03:44:30PM -0700, john stultz wrote:
> The softlockup false positive issue should have been fixed by Peter's
> "x86, intel: Don't mark sched_clock() as stable" below. But I'm not
> seeing it upstream.  Peter, is this still the right fix?

I've not seen any other one proposed, and both you and Peter appeared
to like it. I understood that Ingo was waiting for the merge window to
submit it and I think that it simply got lost.

Ingo, can you confirm ?

Thanks,
Willy

