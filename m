Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2G0OiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:38:17 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:50292 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2G0OiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:38:16 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13737344"
Date: Fri, 27 Jul 2012 15:36:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 02/24] xen/arm: hypercalls
In-Reply-To: <20120727142101.GA6802@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1207271526420.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120726163352.GC9222@phenom.dumpdata.com> <1343380659.6812.106.camel@zakaz.uk.xensource.com>
 <alpine.DEB.2.02.1207271350370.26163@kaball.uk.xensource.com> <20120727142101.GA6802@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Russell King - ARM Linux wrote:
> On Fri, Jul 27, 2012 at 02:02:18PM +0100, Stefano Stabellini wrote:
> > > > > +/******************************************************************************
> > > > > + * hypercall.h
> > > > > + *
> > > > > + * Linux-specific hypervisor handling.
> > > > > + *
> > > > > + * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
> > > > > + *
> > > > > + * This program is free software; you can redistribute it and/or
> > > > > + * modify it under the terms of the GNU General Public License version 2
> > > > > + * as published by the Free Software Foundation; or, when distributed
> > > > > + * separately from the Linux kernel or incorporated into other
> > > > > + * software packages, subject to the following license:
> > > > > + *
> > > > > + * Permission is hereby granted, free of charge, to any person obtaining a copy
> > > > > + * of this source file (the "Software"), to deal in the Software without
> 
> Erm, is that an additional restriction on the GPL which prevents me from
> shipping this code on a CD and charging for the act of creating the CD
> and shipping it?  That would technically make the above statement
> incompatible with the GPL.

IMNAL but this is just an alternative, less strict, MIT license for this
file, same as the x86 counterpart
(arch/x86/include/asm/xen/hypercall.h). The intent is to allow other
operating systems, the BSDs for example, to be able to use it if they
want to.
Actually, given that the ARM implementation is not inline, I should
remember to add this copyright header to the assembly source file too.
