Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2IQOSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:18:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29979 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2IQOSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:18:08 -0400
Date: Mon, 17 Sep 2012 10:06:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 10/24] xen/arm: compile and run xenbus
Message-ID: <20120917140653.GB11996@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
 <1347621207-11294-10-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120917132932.GA11517@phenom.dumpdata.com>
 <alpine.DEB.2.02.1209171444060.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209171444060.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 02:45:00PM +0100, Stefano Stabellini wrote:
> On Mon, 17 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > On Fri, Sep 14, 2012 at 12:13:12PM +0100, Stefano Stabellini wrote:
> > > bind_evtchn_to_irqhandler can legitimately return 0 (irq 0): it is not
> > > an error.
> > > 
> > > If Linux is running as an HVM domain and is running as Dom0, use
> > > xenstored_local_init to initialize the xenstore page and event channel.
> > > 
> > > 
> > > Changes in v4:
> > > 
> > > - do not xs_reset_watches on dom0.
> > > 
> > > 
> > > Changes in v2:
> > > 
> > > - refactor xenbus_init.
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > 
> > If you would like I can also carry this in my tree.
> 
> OK, let's do that. I'll rebase again on your tree with this patch.

Done.
