Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2IQLGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:06:46 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:40861 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab2IQLGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:06:45 -0400
X-IronPort-AV: E=Sophos;i="4.80,434,1344211200"; 
   d="scan'208";a="14577361"
Date: Mon, 17 Sep 2012 12:05:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 10/24] xen/arm: compile and run xenbus
In-Reply-To: <20120914130308.GI25249@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1209171205470.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-10-git-send-email-stefano.stabellini@eu.citrix.com> <20120914130308.GI25249@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 14, 2012 at 12:13:12PM +0100, Stefano Stabellini wrote:
> > bind_evtchn_to_irqhandler can legitimately return 0 (irq 0): it is not
> > an error.
> > 
> > If Linux is running as an HVM domain and is running as Dom0, use
> > xenstored_local_init to initialize the xenstore page and event channel.
> 
> Let me stick it in my tree and see how it works overnight with HVM and PV guests.

Did it work?
