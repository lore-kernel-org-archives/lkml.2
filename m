Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1FXTSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:18:00 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:13744 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab1FXTR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:17:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPLgBE5tgxor/2dsb2JhbABTpz54iHMCwREOhh8Eog8
Date: Fri, 24 Jun 2011 21:17:56 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Lord <kernel@teksavvy.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110624191756.GX23305@infomag.iguana.be>
References: <20110618172537.GH3441@infomag.iguana.be> <20110622201346.GE26745@infomag.iguana.be> <4E034A09.6050107@teksavvy.com> <201106241655.03637.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106241655.03637.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> > > This is another tricky thing were developers will always discuss about.
> > > What you don't want to happen is that the watchdog reboots your system when it does
> > > an fsck at bootup (for instance because the system rebooted by the watchdog and left
> > > the filesystem in a dirty state...).
> > > 
> > > So it's more complex if you look at the overal system...
> > 
> > Sure, but that's got little to do with wanting a kernel parameter to OPTIONALLY
> > enable a hardware watchdog timer at boot.
> > 
> > Filesystem checks are a separate issue, easily worked around in practice.
> 
> I agree, it's nice to give system integrators the option to enable the watchdog
> very early, the problems that Wim mentioned need to be solved in user space
> but are not a serious limitation.

I'm definitely not against it and I am sure that we all agree that this is a valid
option for some drivers (certainly in embedded environments). But for me it has to
stay an option.
FYI: We allready have one driver that does this: w83697hf_wdt.c See commit
6fd656012bb8d5c5a4570adc2e630668b0109cb0.

Kind regards,
Wim.

