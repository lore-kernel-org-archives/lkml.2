Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0IUOQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:16:51 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:8128 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab0IUOQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:16:49 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzzz32i2a8h)
X-WSS-ID: 0L93OUG-01-4TG-02
X-M-MSG: 
Date: Tue, 21 Sep 2010 16:13:30 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        "tdm.rhbz@gmail.com" <tdm.rhbz@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] oprofile: Add Support for Intel CPU Family 6 / Model 29
Message-ID: <20100921141329.GU13563@erda.amd.com>
References: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
 <201009211321.06172.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201009211321.06172.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.09.10 07:21:05, Arnd Bergmann wrote:
> Just curious about the other missing IDs: this now supports all Core
> microarchitecture CPUs, but only some Nehalem/Westmere ones.
> 
> There is support for 0x1a (Bloomfield/Gainestown) and 0x2e (Beckton), but
> not for the much more common 0x1e (Lynnfield/Clarksfield/Jasper Forest),
> 0x25 (Clarkdale/Arrandale) and 0x26 (Gulftown/Westmere-EP).
> 
> Shouldn't those be added as well?
> 
> When you're there, it probably also wouldn't hurt to fill in the blanks
> of some of the older CPUs like Tolopai (0x15) and newer Atoms (0x1c).

Yes, would be nice to have also an update for the remaining
unsupported models. Andi?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

