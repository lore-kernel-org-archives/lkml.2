Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2HBOXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:23:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20534 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab2HBOXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:23:01 -0400
Date: Thu, 2 Aug 2012 10:13:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 01/24] arm: initial Xen support
Message-ID: <20120802141341.GE16749@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <50197527.3070007@gmail.com>
 <1343892951.7571.50.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343892951.7571.50.camel@dagon.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 08:35:51AM +0100, Ian Campbell wrote:
> On Wed, 2012-08-01 at 19:27 +0100, Rob Herring wrote:
> > On 07/26/2012 10:33 AM, Stefano Stabellini wrote:
> > > - Basic hypervisor.h and interface.h definitions.
> > > - Skelethon enlighten.c, set xen_start_info to an empty struct.
> > > - Do not limit xen_initial_domain to PV guests.
> > > 
> > > The new code only compiles when CONFIG_XEN is set, that is going to be
> > > added to arch/arm/Kconfig in a later patch.
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > ---
> > >  arch/arm/Makefile                     |    1 +
> > >  arch/arm/include/asm/hypervisor.h     |    6 +++
> > >  arch/arm/include/asm/xen/hypervisor.h |   19 ++++++++++
> > >  arch/arm/include/asm/xen/interface.h  |   64 +++++++++++++++++++++++++++++++++
> > 
> > These headers don't seem particularly ARM specific. Could they be moved
> > to asm-generic or include/linux?
> 
> Or perhaps include/xen.
> 
> A bunch of it also looks like x86 specific stuff which has crept in.
> e.g. PARAVIRT_LAZY_FOO and paravirt_get_lazy_mode() are arch/x86
> specific and shouldn't be called from common code (and aren't, AFAICT).

The could be moved out..
