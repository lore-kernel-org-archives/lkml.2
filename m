Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2BABIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:08:12 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:50843 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab2BABIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:08:11 -0500
Date: Tue, 31 Jan 2012 21:08:03 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen pvhvm: do not remap pirqs onto evtchns if !xen_have_vector_callback
Message-ID: <20120201010803.GD32295@andromeda.dapyr.net>
References: <alpine.DEB.2.00.1201301429530.3196@kaball-desktop> <20120131162759.GA18248@phenom.dumpdata.com> <alpine.DEB.2.00.1201311636380.3196@kaball-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201311636380.3196@kaball-desktop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 04:40:26PM +0000, Stefano Stabellini wrote:
> On Tue, 31 Jan 2012, Konrad Rzeszutek Wilk wrote:
> > On Mon, Jan 30, 2012 at 02:31:46PM +0000, Stefano Stabellini wrote:
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > So the xen_have_vector_callback looks to be only set by
> > 
> > 1398         if (xen_feature(XENFEAT_hvm_callback_vector))
> > 1399                 xen_have_vector_callback = 1;
> > 
> > So could this be just done via a check for that instead?
> > 
> 
> Sure, but I don't think it would be better: using
> xen_have_vector_callback is more consistent and give us the flexibility
> of allowing users to manually override it in the future.

ok. applied. Hm, I was thinking to put on stable@kernel.org - but how
far back should it go? 2.6.37?
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
