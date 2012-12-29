Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2L2GjJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 01:39:09 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55986 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2L2GjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 01:39:07 -0500
Date: Fri, 28 Dec 2012 22:39:13 -0800
From: Olof Johansson <olof@lixom.net>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/9] ARM: dt: tegra114: Add new SoC base, Tegra 114 SoC
Message-ID: <20121229063913.GA13620@quad.lixom.net>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
 <1355996654-6579-7-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355996654-6579-7-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 11:44:04AM +0200, Hiroshi Doyu wrote:
> Initial support for Tegra 114 SoC. This is expected to be included in
> the board DTS files, Tegra 114 SoC based evaluation board family.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>

Hi,

I think it could be a good idea to start documenting the cpu configuration in
the device tree on some of these larger platforms as well, i.e. include a cpus/
hierarchy. Would you mind adding those, please?

It would give you the flexibility of switching over to using device
tree to probe the number of cpus in case the platform grows yet another
way to figure out the number of cores in the future, without having to
update the device-trees at that time. :)


-Olof
