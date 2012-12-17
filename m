Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2LQVS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:18:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61047 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LQVSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:18:23 -0500
Date: Mon, 17 Dec 2012 13:18:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, stern@rowland.harvard.edu,
        Felipe Balbi <balbi@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        sjg@chromium.org, olof@lixom.net, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: tegra: Add new DT property to USB node.
Message-ID: <20121217211818.GA20835@kroah.com>
References: <1355468348-8821-1-git-send-email-vbyravarasu@nvidia.com>
 <1355468348-8821-2-git-send-email-vbyravarasu@nvidia.com>
 <50CF89AF.3000308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CF89AF.3000308@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 02:07:59PM -0700, Stephen Warren wrote:
> On 12/13/2012 11:59 PM, Venu Byravarasu wrote:
> > As Tegra USB host driver is using instance number for resetting
> > PORT0 twice, adding a new DT property for handling this.
> 
> Alan, Greg, Felip,e
> 
> This series looks fine to me.
> 
> I'd like to take all the Tegra-related USB patches through the Tegra
> tree for 3.9 if possible (so I'm looking for your acks here). I believe
> Venu plans to significantly clean up the EHCI/PHY driver split for
> Tegra, rework the drivers, and add support for Tegra30 in addition to
> Tegra20. Some of this requires changes to some Tegra board files and
> device trees to maintain "git bisect" I don't know for sure yet, but I
> believe that rework may also end up conflicting with other clock-related
> rework that will show up for Tegra in 3.9. Are you OK with this? I'll
> certainly look for your review/acks on the patches before picking them
> up though.

You can't pick anything up for 3.9 until after 3.8-rc1 is out, according
to the rules of linux-next, so please wait until that kernel is out
before doing anything.  Given the timing of 3.8-rc1, and my current
vacation schedule, I'm not going to be able to do _any_ code review for
the rest of the year, sorry.

After that, I'll be glad to review this.

greg k-h
