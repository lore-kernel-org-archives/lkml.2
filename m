Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2EUPnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:43:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48656 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2EUPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:43:31 -0400
Date: Mon, 21 May 2012 10:40:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] hvc_xen: NULL dereference on allocation failure
Message-ID: <20120521144053.GA24239@phenom.dumpdata.com>
References: <20120515084746.GC30265@elgon.mountain>
 <alpine.DEB.2.00.1205151119260.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205151119260.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 11:20:23AM +0100, Stefano Stabellini wrote:
> On Tue, 15 May 2012, Dan Carpenter wrote:
> > If kzalloc() returns a NULL here, we pass a NULL to
> > xencons_disconnect_backend() which will cause an Oops.
> > 
> > Also I removed the __GFP_ZERO while I was at it since kzalloc() implies
> > __GFP_ZERO.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

applied.
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
