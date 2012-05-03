Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2ECSki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:40:38 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:39881 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab2ECSkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:40:37 -0400
Date: Thu, 3 May 2012 20:40:08 +0200
From: Nico Schottelius <nico-linux-20120419@schottelius.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Francois Rigaut <frigaut@gmail.com>,
        Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120503184008.GB9432@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20120419@schottelius.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Francois Rigaut <frigaut@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120419163800.GB13977@schottelius.org>
 <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com>
 <20120502163629.GE928@schottelius.org>
 <20120502202509.GA26798@kroah.com>
 <20120503065003.GB13386@schottelius.org>
 <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com>
 <20120503153547.GD20334@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503153547.GD20334@kroah.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.3.3-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Greg KH [Thu, May 03, 2012 at 08:35:47AM -0700]:
> [...]
> 
> How about if you load the acpiphp module instead?  Some BIOSes use that
> instead of pciehp.
> 
> You need one of those drivers in order for this to work properly.
> 
> Also, speaking of BIOS, make sure you have the latest updates, there
> were a lot of initial problems with Thunderbolt hotplug issues that were
> fixed in newer BIOS versions, so that will be required to be updated.

I'm confused - to which BIOS are you referring to? I understood that
Apple's Mac Book Air has its custom "similar to EFI" (*) code and not a
traditional BIOS in place.

Cheers,

Nico

(*) Which would also be interesting to replace with something like
    LinuxBios/Coreboot.

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
