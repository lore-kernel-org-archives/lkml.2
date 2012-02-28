Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585Ab2B1MPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 07:15:04 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:8627 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250Ab2B1MPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 07:15:02 -0500
X-IronPort-AV: E=Sophos;i="4.73,495,1325462400"; 
   d="scan'208";a="10980931"
Date: Tue, 28 Feb 2012 12:21:37 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Dave Martin <dave.martin@linaro.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
In-Reply-To: <20120228094616.GA2063@linaro.org>
Message-ID: <alpine.DEB.2.00.1202281131550.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop> <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120227175327.GA2023@linaro.org> <1330372125.10008.47.camel@dagon.hellion.org.uk> <20120228094616.GA2063@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012, Dave Martin wrote:
> > Given that Stefano is proposing to make the ISS a (per-hypervisor)
> > constant we could consider just defining the Thumb and non-Thumb
> > constants instead of doing all the construction with the __HVC_IMM stuff
> > -- that would remove a big bit of the macroization.
> 
> It's not quite as simple as that -- emitting instructions using data
> directives is not endianness safe, and even in the cases where .long gives
> the right result for ARM, it gives the wrong result for 32-bit Thumb
> instructions if the opcode is given in human-readable order.
> 
> I was trying to solve the same problem for the kvm guys with some global
> macros -- I'm aiming to get a patch posted soon, so I'll make sure
> you're on CC.
 
That would be great, thanks!
