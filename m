Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0KLDQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:16:03 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:15949 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0KLDQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:16:02 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJg/3EyrR7Ht/2dsb2JhbACiTHGkNZsehUoEhFqFfg
X-IronPort-AV: E=Sophos;i="4.59,186,1288569600"; 
   d="scan'208";a="380135250"
From: Roland Dreier <rdreier@cisco.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <greg@kroah.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
	<AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
	<20101107155757.GA13736@kroah.com>
	<AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
	<20101107215908.GA21070@kroah.com> <adar5esn1gd.fsf@cisco.com>
	<alpine.LFD.2.00.1011110139200.2900@localhost6.localdomain6>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 11 Nov 2010 19:15:56 -0800
In-Reply-To: <alpine.LFD.2.00.1011110139200.2900@localhost6.localdomain6>
	(Thomas Gleixner's message of "Thu, 11 Nov 2010 01:40:54 +0100 (CET)")
Message-ID: <adawrojkz9v.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  > Isn't the openwrt stuff just drivers and some arch specific code?
 > >  > Nothing that is core infrastructure, and nothing preventing them from
 > >  > submitting the drivers and arch code if they want to, right?
 > > 
 > > Actually openwrt has some core infrastructure for managing (ethernet)
 > > switches as extra-fancy multiport PHYs.  That means that all the drivers
 > > in openwrt for the typical 5-8 port switches in home routers don't
 > > really apply to mainline.
 > 
 > Why not? Those switches _ARE_ extra-fancy multiport PHYs. And AFAICT
 > we have no support for this stuff in mainline at all.
 > 
 > So where is the problem ?

There's no real problem.  I was just pointing out that the openwrt
switch stuff actually does have some core infrastructure that mainline
is missing.  ie openwrt is not just drivers and arch code.

But yes I agree mainline should really do a better job of supporting
ethernet switches, and clearly openwrt has the most real-world
experience with implementing that.

 - R.
