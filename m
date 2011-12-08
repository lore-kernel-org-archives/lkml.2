Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1LHJ2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:28:05 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:43991 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1LHJ2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:28:02 -0500
Date: Thu, 8 Dec 2011 10:27:58 +0100
From: Bastian Blank <waldi@debian.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 3/4] xen: Add xenbusd device driver
Message-ID: <20111208092757.GA22678@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Ian Campbell <Ian.Campbell@citrix.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
 <1323292396-19523-4-git-send-email-waldi@debian.org>
 <1323332686.2969.49.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1323332686.2969.49.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 08:24:46AM +0000, Ian Campbell wrote:
> On Wed, 2011-12-07 at 21:13 +0000, Bastian Blank wrote:
> > +obj-$(CONFIG_XEN_BACKEND) += xenbus_dev_backend.o
> In principal this could be its own module which does not depend on any
> of the backend stuff but I think this is fine for now.

I even think about registering this device from xenstored_local_init in
xenbus_probe.c. Then it will be available only if the kernel also owns
the communcation ring.

> "Could not register xenbus backend device" to distinguish from the f.e.
> failure message, you could also add "frontend" there I suppose. Other
> than that:

Yep.

Will someone mind if I rename this device to xenbus_backend? It's more
clear.

Bastian

-- 
Deflector shields just came on, Captain.
