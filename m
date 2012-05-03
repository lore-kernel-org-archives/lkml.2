Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2ECG7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:59:49 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:60170 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab2ECG7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:59:48 -0400
Date: Thu, 3 May 2012 08:50:03 +0200
From: Nico Schottelius <nico-linux-20120419@schottelius.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nico Schottelius <nico-linux-20120419@schottelius.org>,
        Francois Rigaut <frigaut@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120503065003.GB13386@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20120419@schottelius.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Francois Rigaut <frigaut@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120419163800.GB13977@schottelius.org>
 <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com>
 <20120502163629.GE928@schottelius.org>
 <20120502202509.GA26798@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502202509.GA26798@kroah.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.3.3-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH [Wed, May 02, 2012 at 01:25:09PM -0700]:
> Thunderbolt should show up to the kernel just as a "normal" PCIE link,
> so there shouldn't be anything special we need to do to handle this at
> all (or at least my Intel contacts said that.)

Well, at least from my lspci point of view (before/after disconnect same
output), this seems to be wrong (no dmesg output as well).

Additionally as far as I understand
thunderbolt, it's bundling display port and pci-e into a single channel,
so I'm not sure if this is 100% transparent pci-e + displayport from our
side.

Or, the better question is probably: How should Linux realise that there
is a change (apple monitor with ethernet, usb, co. plugged in) going on?

> Note, I haven't tested this yet, so I can't verify it, but if you have
> the hardware, you should be able to.

I can test stuff here, but would be thankful for a round of pointers on
how to debug / approach this.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
