Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2G0Ojf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:39:35 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:63002 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2G0Oje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:39:34 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13737399"
Message-ID: <1343399971.25096.8.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 02/24] xen/arm: hypercalls
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 27 Jul 2012 15:39:31 +0100
In-Reply-To: <20120727142101.GA6802@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	 <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20120726163352.GC9222@phenom.dumpdata.com>
	 <1343380659.6812.106.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1207271350370.26163@kaball.uk.xensource.com>
	 <20120727142101.GA6802@n2100.arm.linux.org.uk>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 15:21 +0100, Russell King - ARM Linux wrote:
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

There's an "or" in there.

The non-GPL alternative license is the standard one applied by upstream
Xen to the interface headers:
        http://xenbits.xen.org/hg/xen-unstable.hg/file/tip/xen/include/public/COPYING

It's the X11/MIT license IIRC, which the FSF say is GPL compatible.
http://www.gnu.org/licenses/license-list.html#X11License

The same license is used a few other places in the kernel, e.g. the DRM
code.

Ian.


