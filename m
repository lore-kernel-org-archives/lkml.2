Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab0FBDxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:53:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48134 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab0FBDxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:53:14 -0400
Date: Tue, 1 Jun 2010 21:53:09 -0600
From: Alex Chiang <achiang@canonical.com>
To: David Miller <davem@davemloft.net>, mikpe@it.uu.se,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [2.6.35-rc1 regression] sysfs: cannot create duplicate
 filename ... XVR-600 related?
Message-ID: <20100602035309.GA2849@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	David Miller <davem@davemloft.net>, mikpe@it.uu.se,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
References: <19461.26166.427857.612983@pilspetsen.it.uu.se>
 <20100601.153105.90813554.davem@davemloft.net>
 <20100602030925.GA3402@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602030925.GA3402@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@canonical.com>:
> * David Miller <davem@davemloft.net>:
> > From: Mikael Pettersson <mikpe@it.uu.se>
> > Date: Tue, 1 Jun 2010 21:57:42 +0200
> > 
> > > Booting 2.6.35-rc1 on a Sun Blade 2500 Red, I'm greeted with:
> > 
> > I know about the problem and will look at it soon hopefully, I see it
> > on some of my sparc64 boxes too.
>  
> I haven't been able to reproduce this yet (trying with kvm, not
> successful with bare metal), but one thing I've noticed is that
> it occurs when either a PCI hotplug driver or the ACPI PCI slot
> detection driver is loaded.

Hm. If acpiphp is a built-in, I get the warnings (in kvm). If
it's a module, no warnings, not even after modprobing.

Continuing to dig...

/ac
