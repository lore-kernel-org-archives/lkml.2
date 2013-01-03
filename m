Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3ACGjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:39:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5468 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3ACGjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:39:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 02 Jan 2013 22:36:20 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 3 Jan 2013 07:38:48 +0100
Subject: Re: [PATCH 4/4] ARM: tegra: Set SCU base address dynamically from DT
Thread-Topic: [PATCH 4/4] ARM: tegra: Set SCU base address dynamically from
 DT
Thread-Index: Ac3pfP2zk6N3IFEvSwiI77fHII3C2Q==
Message-ID: <20130103.083848.1533296860718294309.hdoyu@nvidia.com>
References: <1355725087-11363-1-git-send-email-hdoyu@nvidia.com><1355725087-11363-4-git-send-email-hdoyu@nvidia.com><50E4845D.6020809@wwwdotorg.org>
In-Reply-To: <50E4845D.6020809@wwwdotorg.org>
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

Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 2 Jan 2013 20:02:53 +0100:

> On 12/16/2012 11:18 PM, Hiroshi Doyu wrote:
> > Set Snoop Control Unit(SCU) register base address dynamically from DT.
> 
> Hiroshi, what's the status on this patch series? I think Rob had
> comments/objections on patch 4; are you going to post an updated series,
> or is this series replaced by patch 3 in your Tegra114 series?

As Rob suggested, at least, SCU base address should be detected in
common code, scu_of_init() even if DT /cpus is the primary way to
detect # of cores. I'll repost later.

This patch can be done independent of Tegra114 series.
