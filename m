Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab2LaHMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 02:12:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2765 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2LaHMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 02:12:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 30 Dec 2012 23:12:15 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "olof@lixom.net" <olof@lixom.net>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 31 Dec 2012 08:12:05 +0100
Subject: Re: [PATCH 6/9] ARM: dt: tegra114: Add new SoC base, Tegra 114 SoC
Thread-Topic: [PATCH 6/9] ARM: dt: tegra114: Add new SoC base, Tegra 114 SoC
Thread-Index: Ac3nJifDdNWHtO8MSW+4d5DfuEoJUA==
Message-ID: <20121231.091205.1954307462967637866.hdoyu@nvidia.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com><1355996654-6579-7-git-send-email-hdoyu@nvidia.com><20121229063913.GA13620@quad.lixom.net>
In-Reply-To: <20121229063913.GA13620@quad.lixom.net>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

Olof Johansson <olof@lixom.net> wrote @ Sat, 29 Dec 2012 07:39:13 +0100:

> On Thu, Dec 20, 2012 at 11:44:04AM +0200, Hiroshi Doyu wrote:
> > Initial support for Tegra 114 SoC. This is expected to be included in
> > the board DTS files, Tegra 114 SoC based evaluation board family.
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> 
> Hi,
> 
> I think it could be a good idea to start documenting the cpu configuration in
> the device tree on some of these larger platforms as well, i.e. include a cpus/
> hierarchy. Would you mind adding those, please?

Ok, I'll.

> It would give you the flexibility of switching over to using device
> tree to probe the number of cpus in case the platform grows yet another
> way to figure out the number of cores in the future, without having to
> update the device-trees at that time. :)
> 
> 
> -Olof
