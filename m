Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1ANK51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:57:27 -0500
Received: from www.tglx.de ([62.245.132.106]:43467 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1ANK5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:57:20 -0500
Date: Fri, 14 Jan 2011 11:57:09 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com, Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH v2 01/15] x86/e820: remove conditional early mapping in parse_e820_ext
Message-ID: <20110114105709.GA7562@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-2-git-send-email-bigeasy@linutronix.de> <20101230083745.GC11721@angua.secretlab.ca> <20110104130839.GA21359@www.tglx.de> <20110114081446.GC21832@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110114081446.GC21832@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-01-14 01:14:46 [-0700]:

>Hey Sebastian,
Hi Grant,

thanks for doing this.

>Can you please repost this series after the merge window closes?  Some
>of the patches have been reworked and reposted, but I've kind of lost
>track of which ones need my attention.  Also, some of the patches have
Yes, this was my secret plan :) I also had to rework patches because of
other patches either because they no longer applied or because the code
had to change in order to work again.

In case "[v2,13/15] x86/rtc: don't register rtc if we the DT blob" [0]
goes into the category "lost track" and not "had no time to reply" could
please take a look? The important part is where it could change behavior
for OLPC and it migh end up without a RTC. I Cc Andres Salomon as might
know where the RTC on OLPC is comming from.

>gone in via the tip tree, so it would be useful to regroup and figure
>out which ones are no longer needed.
I try to regroup and a add TIP or OF prefix.

>I'll be able to take a fresh look and pick up the ones that are ready
>after the merge window closes.
Okay.

>Thanks,
>g.

[0] https://patchwork.kernel.org/patch/450681/

Sebastian
