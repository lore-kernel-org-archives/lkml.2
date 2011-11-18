Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1KRStn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:49:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61246 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab1KRStl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:49:41 -0500
Date: Fri, 18 Nov 2011 10:49:42 -0800
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 01/10] arm/tegra: initial device tree for tegra30
Message-ID: <20111118184942.GA31678@quad.lixom.net>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-2-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74C46@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740D74C46@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 11:39:14AM -0800, Stephen Warren wrote:
> Peter De Schrijver wrote at Thursday, November 17, 2011 9:19 AM:
> > This patch adds the initial device tree for tegra30
> 
> > diff --git a/Documentation/devicetree/bindings/arm/tegra.txt
> ...
> > +* harmony: tegra20 based development board
> > +Required root node properties:
> > + - compatible = "nvidia,harmony", "nvidia,tegra20";
> > +
> > +* seaboard: tegra20 based clamshell reference design
> > +Required root node properties:
> > + - compatible = "nvidia,seaboard", "nvidia,tegra20";
> 
> Do we really want to list all the board names here? In the future, there
> could be tens or hundreds. I would argue that we should just document
> nvidia,tegra20 and nvidia,tegra30.

Agreed.

> At a later point, we should fix board-dt.c to solely look for those
> compatible values, although this will have to wait until the pinmux DT
> bindings are present. Then, the kernel won't care about the board names.

Exactly.


-Olof
