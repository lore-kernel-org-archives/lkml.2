Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2EOKVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:21:09 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:2556 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2EOKVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:21:07 -0400
X-IronPort-AV: E=Sophos;i="4.75,593,1330905600"; 
   d="scan'208";a="12478371"
Date: Tue, 15 May 2012 11:20:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alan Cox <alan@linux.intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] hvc_xen: NULL dereference on allocation failure
In-Reply-To: <20120515084746.GC30265@elgon.mountain>
Message-ID: <alpine.DEB.2.00.1205151119260.26786@kaball-desktop>
References: <20120515084746.GC30265@elgon.mountain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Dan Carpenter wrote:
> If kzalloc() returns a NULL here, we pass a NULL to
> xencons_disconnect_backend() which will cause an Oops.
> 
> Also I removed the __GFP_ZERO while I was at it since kzalloc() implies
> __GFP_ZERO.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
 
