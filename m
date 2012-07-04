Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab2GDL1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:27:51 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:26622 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab2GDL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:27:50 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336348800"; 
   d="scan'208";a="13364422"
Date: Wed, 4 Jul 2012 12:27:17 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH WIP 2/5] xen/arm: set xen_platform_pci_unplug to
 XEN_UNPLUG_ALL
In-Reply-To: <4FF4281E.9040801@citrix.com>
Message-ID: <alpine.DEB.2.02.1207041226150.31911@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>  <1341400520-31770-2-git-send-email-stefano.stabellini@eu.citrix.com> <4FF4281E.9040801@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, David Vrabel wrote:
> On 04/07/12 12:15, Stefano Stabellini wrote:
> > Set xen_platform_pci_unplug to XEN_UNPLUG_ALL by default to make
> > blkfront happy. The parameter doesn't make sense on ARM and should be
> > removed.
> 
> Why is this parameter nonsensical on ARM?  ARM systems can have PCI devices.

Because we shouldn't assume the presence of a PCI bus on ARM. Moreover
it would be nice to avoid the ugly unplug protocol entirely if we can.
