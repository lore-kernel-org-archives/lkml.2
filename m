Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0JTQpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:45:30 -0400
Received: from sous-sol.org ([216.99.217.87]:35963 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754117Ab0JTQp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:45:28 -0400
Date: Wed, 20 Oct 2010 09:43:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
        linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Xen-devel] Re: xen PV on HVM and initial domain merge in
 linux-next
Message-ID: <20101020164352.GL25455@sequoia.sous-sol.org>
References: <alpine.DEB.2.00.1010191254460.2423@kaball-desktop>
 <alpine.DEB.2.00.1010191847290.10348@kaball-desktop20101020113256.3647b1d9.sfr@canb.auug.org.au>
 <5d143f14-26a1-4452-8b44-dae2a8b6df11@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d143f14-26a1-4452-8b44-dae2a8b6df11@default>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Magenheimer (dan.magenheimer@oracle.com) wrote:
> > Not following the Xen develpment at all, I would like to have a
> > positive reply from the listed Xen contacts, please,
> 
> I am not officially listed as a maintainer for Xen, but fwiw:
> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> And, Stephen, I think Chris Wright and virtualization@lists.osdl.org
> are stale entries in the MAINTAINERS file for Xen development,
> so you are unlikely to receive replies from him/them.
> (Chris, virtualization@lists.osdl.org ... please feel free
> to correct me if I am wrong.)

Yeah, I'm not really doing Xen pv stuff these days.
The virtualization list itself is always open, and it's useful for
things that cross over (e.g. virtio, pv clock, pv spinlocks).

thanks,
-chris
