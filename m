Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab1JNUOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:14:14 -0400
Received: from relais.videotron.ca ([24.201.245.36]:58164 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1JNUON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:14:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 16:14:12 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
In-reply-to: <20111014192057.GT21648@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1110141609510.17040@xanadu.home>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <201110141729.41515.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
 <201110141827.53906.arnd@arndb.de>
 <alpine.LFD.2.02.1110141353390.17040@xanadu.home>
 <20111014192057.GT21648@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Russell King - ARM Linux wrote:

> On Fri, Oct 14, 2011 at 02:01:07PM -0400, Nicolas Pitre wrote:
> > The way I'm restructuring things around this is that AUTO_ZRELADDR will 
> > always be active by default, just like ARM_PATCH_PHYS_VIRT now.  This 
> > platform specific exclusion thinking is a step backward so I'd prefer if 
> > people would refrain from going there for the moment.
> 
> Are you expecting everyone to change the way they load the zImage
> overnight then?

No, of course.  But adding restrictions in the kernel build because 
u-Boot's own image format dictates such restrictions doesn't make sense.  
Those restrictions must be pushed towards the uImage encapsulation step, 
not higher the kernel config hierarchy.


Nicolas
