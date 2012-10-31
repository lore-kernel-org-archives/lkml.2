Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935825Ab2JaQX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:23:26 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:55929 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935728Ab2JaQXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:23:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ksNqale1vL9RfxRIkgJgx
Date: Wed, 31 Oct 2012 09:23:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Clark <rob@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the staging
 tree
Message-ID: <20121031162314.GD12739@atomide.com>
References: <20121031161921.3c9a46bd03f5864eed88fc87@canb.auug.org.au>
 <20121031161614.GF31804@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031161614.GF31804@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com> [121031 09:17]:
> On Wed, Oct 31, 2012 at 04:19:21PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mach-omap2/drm.c between commit 5e3b08749951 ("staging:
> > drm/omap: add support for ARCH_MULTIPLATFORM") from the staging tree and
> > commit 2a296c8f89bc ("ARM: OMAP: Make plat/omap_hwmod.h local to
> > mach-omap2") from the arm-soc tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> 
> Looks good to me, thanks for this.

Yes thanks.

Tony
