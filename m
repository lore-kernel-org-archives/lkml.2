Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1LHJdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:33:18 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:51340 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1LHJdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:33:15 -0500
X-IronPort-AV: E=Sophos;i="4.71,319,1320624000"; 
   d="scan'208";a="9357371"
Subject: Re: [Xen-devel] [PATCH 3/4] xen: Add xenbusd device driver
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bastian Blank <waldi@debian.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Thu, 8 Dec 2011 09:32:57 +0000
In-Reply-To: <20111208092757.GA22678@wavehammer.waldi.eu.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
	 <1323292396-19523-4-git-send-email-waldi@debian.org>
	 <1323332686.2969.49.camel@zakaz.uk.xensource.com>
	 <20111208092757.GA22678@wavehammer.waldi.eu.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323336777.2969.73.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 09:27 +0000, Bastian Blank wrote:
> On Thu, Dec 08, 2011 at 08:24:46AM +0000, Ian Campbell wrote:
> > On Wed, 2011-12-07 at 21:13 +0000, Bastian Blank wrote:
> > > +obj-$(CONFIG_XEN_BACKEND) += xenbus_dev_backend.o
> > In principal this could be its own module which does not depend on any
> > of the backend stuff but I think this is fine for now.
> 
> I even think about registering this device from xenstored_local_init in
> xenbus_probe.c. Then it will be available only if the kernel also owns
> the communcation ring.

That sounds like a good idea.

> > "Could not register xenbus backend device" to distinguish from the f.e.
> > failure message, you could also add "frontend" there I suppose. Other
> > than that:
> 
> Yep.
> 
> Will someone mind if I rename this device to xenbus_backend? It's more
> clear.

It's ok by me. You could even use "xenstored"?

Ian.

