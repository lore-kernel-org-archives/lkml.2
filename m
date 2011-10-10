Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1JJUEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:04:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18857 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1JJUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:04:06 -0400
Date: Mon, 10 Oct 2011 15:57:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Li Dongyang <lidongyang@novell.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
Message-ID: <20111010195749.GA5755@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
 <20111010164250.GG28646@phenom.oracle.com>
 <1318274402.27397.13.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318274402.27397.13.camel@dagon.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090208.4E934FAF.0036,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 08:20:02PM +0100, Ian Campbell wrote:
> On Mon, 2011-10-10 at 17:42 +0100, Konrad Rzeszutek Wilk wrote:
> > On Mon, Oct 10, 2011 at 05:13:07PM +0100, Ian Campbell wrote:
> 
> > > In any case it should also be posted against the canonical inter-guest
> > > interface definition in the xen tree for review with that in mind.
> > 
> > Yes! But I was thinking to first let this one rattle a bit and see what
> > folks thought about it before submitting the xen-devel.
> 
> It's a good idea to get ABI changes out for review before the
> implementation rattles around so much that changing it becomes hard.

OK, lets drop this until we get that straigthen out. I've posted
http://lists.xensource.com/archives/html/xen-devel/2011-10/msg00642.html the changes to
Xen ABI.
