Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2IQOHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:07:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37292 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2IQOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:07:44 -0400
Date: Mon, 17 Sep 2012 09:56:37 -0400
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
Message-ID: <20120917135637.GG11553@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
 <1347621207-11294-10-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120914130308.GI25249@phenom.dumpdata.com>
 <alpine.DEB.2.02.1209171205470.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209171205470.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:05:59PM +0100, Stefano Stabellini wrote:
> On Fri, 14 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > On Fri, Sep 14, 2012 at 12:13:12PM +0100, Stefano Stabellini wrote:
> > > bind_evtchn_to_irqhandler can legitimately return 0 (irq 0): it is not
> > > an error.
> > > 
> > > If Linux is running as an HVM domain and is running as Dom0, use
> > > xenstored_local_init to initialize the xenstore page and event channel.
> > 
> > Let me stick it in my tree and see how it works overnight with HVM and PV guests.
> 
> Did it work?

Yes!
