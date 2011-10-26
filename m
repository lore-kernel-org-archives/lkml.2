Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707Ab1JZSWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 14:22:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab1JZSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 14:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <1319582670.17505.31.camel@work-vm>
References: <1310690138.3367.61.camel@work-vm> <1310724097.2586.296.camel@twins>
 <1310752795.2945.4.camel@work-vm> <20110721072256.GE9216@elte.hu>
 <1311251098.29152.130.camel@twins> <20110721125008.GF11246@pcnci.linuxbox.cz>
 <1311252799.29152.147.camel@twins> <20110721184524.GB381@elte.hu>
 <20110825185616.GA17078@faidon.noc.grnet.gr> <20110830223829.GB17450@kroah.com>
 <20110904232657.GC6749@tty.gr> <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com>
 <1319582670.17505.31.camel@work-vm>
From: Ruben Kerkhof <ruben@rubenkerkhof.com>
Date: Wed, 26 Oct 2011 20:21:53 +0200
Message-ID: <CAPed3OE0YSedYVfQvEkzdqpeaQWDNdiGHBSKYR1PcqVsHE26VA@mail.gmail.com>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
To: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org,
        =?UTF-8?Q?Herv=C3=A9_Commowick?= <hcommowick@exosec.fr>,
        Rand@jasper.es, Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>, Faidon Liambotis <paravoid@debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 00:44, john stultz <johnstul@us.ibm.com> wrote:
> On Sun, 2011-10-23 at 20:31 +0200, Ruben Kerkhof wrote:

>> I just had two crashes on two different machines, both with an uptime
>> of 208 days.
>> Both were 5520's running 2.6.34.8, but with a CONFIG_HZ of 1000
>>
>> 2011-10-23T16:49:18.618029+02:00 phy001 kernel: BUG: soft lockup -
>> CPU#0 stuck for 17163091968s! [qemu-kvm:16949]
>
> So were these actual crashes, or just softlockup false positives?

Just softlockups, I haven't seen the divide_by_zero crash.

Thanks,

Ruben
