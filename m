Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2GTOpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:45:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48763 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2GTOo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:44:59 -0400
Date: Fri, 20 Jul 2012 10:36:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH WIP 6/6] xen/arm: enable evtchn irqs
Message-ID: <20120720143609.GA21870@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1340381685-22529-6-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120709144005.GA12102@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207131749470.23783@kaball.uk.xensource.com>
 <20120716145709.GB552@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207181750500.23783@kaball.uk.xensource.com>
 <20120719233045.GA944@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207201208230.23783@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207201208230.23783@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 12:09:56PM +0100, Stefano Stabellini wrote:
> On Fri, 20 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > > OK, please include those questions/answers in the git commit and
> > > > repost.
> > 
> > I seem to be missing the rest of the patches. I see the drivers/xen/events also
> > has the  xen_init_IRQ_arm... is there a git tree with the base patches?
> 
> Yes, the latest git tree, based on
> 55b02d2f4445ad625213817a1736bf2884d32547, is available here:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git xenarmv7-3

Uh there is a bit of stuff there. Can you just repost those you want me to
review and Ack that touch common code?

Or are you posting them to collect feedback/Acks and then want to post them
as a bigger set?

> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
