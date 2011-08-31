Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab1HaS0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 14:26:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18439 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1HaS0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 14:26:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 31 Aug 2011 11:25:55 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>
Date: Wed, 31 Aug 2011 11:25:52 -0700
Subject: RE: [PATCH v3 06/13] dt: add empty for_each_child_of_node,
 of_find_property
Thread-Topic: [PATCH v3 06/13] dt: add empty for_each_child_of_node,
 of_find_property
Thread-Index: AcxjgOLqxM+UdHhgSYSh4D5it7cLXwEikm2Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A062@HQMAIL01.nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
 <1314315824-9687-7-git-send-email-swarren@nvidia.com>
In-Reply-To: <1314315824-9687-7-git-send-email-swarren@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren wrote at Thursday, August 25, 2011 5:44 PM:
> The patch adds a couple empty functions for non-dt build, so that
> drivers migrating to dt can save some '#ifdef CONFIG_OF'.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Grant, is there any chance you could apply this one patch without waiting
for the whole series; I just realized that the SDHCI controller changes
I published yesterday rely on this patch to compile. While I did compile-
check them without CONFIG_OF, I also had this patch in that branch and
didn't notice the problem.

Thanks.

-- 
nvpublic

