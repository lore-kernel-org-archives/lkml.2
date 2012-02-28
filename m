Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2B1KHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:07:19 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:35216 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab2B1KHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:07:17 -0500
X-IronPort-AV: E=Sophos;i="4.73,495,1325462400"; 
   d="scan'208";a="10977066"
Message-ID: <1330423635.31269.40.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Dave Martin <dave.martin@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 28 Feb 2012 10:07:15 +0000
In-Reply-To: <20120228094616.GA2063@linaro.org>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20120227175327.GA2023@linaro.org>
	 <1330372125.10008.47.camel@dagon.hellion.org.uk>
	 <20120228094616.GA2063@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 09:46 +0000, Dave Martin wrote:
> On Mon, Feb 27, 2012 at 07:48:45PM +0000, Ian Campbell wrote:
> > Given that Stefano is proposing to make the ISS a (per-hypervisor)
> > constant we could consider just defining the Thumb and non-Thumb
> > constants instead of doing all the construction with the __HVC_IMM stuff
> > -- that would remove a big bit of the macroization.
> 
> It's not quite as simple as that -- emitting instructions using data
> directives is not endianness safe, and even in the cases where .long gives
> the right result for ARM, it gives the wrong result for 32-bit Thumb
> instructions if the opcode is given in human-readable order.

Urk, yes,..

> I was trying to solve the same problem for the kvm guys with some global
> macros -- I'm aiming to get a patch posted soon, so I'll make sure
> you're on CC.

Awesome, thanks!

Ian.

