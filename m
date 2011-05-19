Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab1ESQTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:19:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40107 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab1ESQTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:19:20 -0400
Date: Thu, 19 May 2011 12:18:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] RE: [PATCH v2 2/2] x86: don't unmask disabled irqs
 when migrating them
Message-ID: <20110519161854.GA12940@dumpdata.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.02.1105061149330.3005@ionos>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7FB9F@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105091301040.10886@kaball-desktop>
 <alpine.LFD.2.02.1105091435350.2843@ionos>
 <625BA99ED14B2D499DC4E29D8138F1505C8F008B68@shsmsx502.ccr.corp.intel.com>
 <625BA99ED14B2D499DC4E29D8138F1505C9BBF8D40@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105191304530.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105191304530.12963@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DD542FB.0109:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 01:08:07PM +0100, Stefano Stabellini wrote:
> On Thu, 19 May 2011, Tian, Kevin wrote:
> > for [1/2] I think it's still necessary as it's meaningless to migrate a percpu type irq.
> > However Stefano has sent out a cleanup patch for Xen percpu irqchip which uses
> > nop mask/unmask hack borrowed from uv machine to work around the issue. As
> > you suggested it's better to consolidate into the common place instead of scattering
> > in different places. My view on this common logic is what [1/2] tries to address, is
> > it correct? If yes, would you consider taking this patch? Stefano told me that his
> > patches will go in in next merge window. So I think either you can take [1/2] now and
> > then I'll do cleanup after Stefano's patch is in, or I can rebase my [1/2] after Stefano's
> > patch to clean both xen and uv parts. 
> 
> Actually I think Kevin's generic patch is better too.
> If you ack it I'll remove my patch right away from the queue (maybe I
> should remove it anyway?).

I dropped your patch.
