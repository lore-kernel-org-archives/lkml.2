Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab1COLmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:42:33 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9462 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab1COLm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:42:29 -0400
X-IronPort-AV: E=Sophos;i="4.62,322,1297036800"; 
   d="scan'208";a="4793963"
Date: Tue, 15 Mar 2011 11:41:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Olaf Hering <olaf@aepfle.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH] input/xen-fbfront: advertise either absolute or relative
 coordinates
In-Reply-To: <20110315050024.GB1046@core.coreip.homeip.net>
Message-ID: <alpine.DEB.2.00.1103151139060.3382@kaball-desktop>
References: <alpine.DEB.2.00.1103111124400.2968@kaball-desktop> <20110313062411.GB31566@core.coreip.homeip.net> <20110314100144.GA4572@aepfle.de> <20110315050024.GB1046@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Dmitry Torokhov wrote:
> > Yes, as mentioned in the description above, using absolute coordinates in
> > the guests X11 is prefered because it avoids that the guest mouse
> > pointer gets out of sync with the host/desktop mouse pointer.
> > Very old Xen versions did not send absolute coordinates, but recent
> > versions do.
> > 
> 
> OK, as long as we have understanding that there is no concern with
> migrating to a version of hypervisor that does not support absolute
> coordinates reporting.
> 

Absolute coordinates have been present in xenfb since years now, so I
don't think is a concern anymore.


> BTW, I believe the code should be rearranged a bit, like in the patch
> below (this way we do not set up abs params if device works in relative
> mode).

Looks fine, thanks!
Would you be OK with carrying this patch in your tree or do you want me
to add it to mine?
