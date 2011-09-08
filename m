Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1IHXOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:14:49 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:61977 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1IHXOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:14:21 -0400
X-IronPort-AV: E=Sophos;i="4.68,351,1312156800"; 
   d="scan'208";a="7684378"
Date: Thu, 8 Sep 2011 19:47:48 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v4 0/2] xen: modify kernel mappings corresponding to
 granted pages
In-Reply-To: <alpine.DEB.2.00.1109081357000.12963@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1109081946490.12963@kaball-desktop>
References: <alpine.DEB.2.00.1109081357000.12963@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011, Stefano Stabellini wrote:
> Hi all,
> this is the forth version of the patch "xen: modify kernel mappings
> corresponding to granted pages":
> 
> changes to v3:
> 
> - move the xen_mc_entry call in m2p_remove_override after the
> xen_mc_flush call;
> 
> - use false rather than 0 as a parameter to alloc_xenballooned_pages;
> 
> - update the m2p_add_override call in blkback.c, following the new
> interface;
> 
> - fix few code style issues.
> 

Sorry for not having sent the patch with --in-reply-to but I had an
issue with my git-send-email setup so I had to send them manually...
