Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2D3Or5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 10:47:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49988 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2D3Or4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 10:47:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add AHB driver
Date: Mon, 30 Apr 2012 14:47:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com> <20120426215903.GH24211@n2100.arm.linux.org.uk> <20120427084015.cb7c8e00c7d9a4cd01faa5ae@nvidia.com>
In-Reply-To: <20120427084015.cb7c8e00c7d9a4cd01faa5ae@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301447.36246.arnd@arndb.de>
X-Provags-ID: V02:K0:K+EKrP78lvTEltutYGjdZT6Tl2+ZsoMKsK6PYBrbsWA
 +tX/oEYBG8LYS/qfEicAW7TBJgaqXD/yvpCQDxKrWtRMD3nLMb
 ddsCQ7UJYh9KVyfcNbRxwV7+1tdpV7lq8plmpm4EjQ4zA3T2T2
 5DLps42/pIBj1fLN1aWQsfPevXibHbkULWHo8azUbuKOlTnTzp
 2KqVOeyNBdA06z4tqhjMs6s134Ex6q+UopFgN0VWn8o1w6FeJQ
 jrYWV1PAFRahiwNaMVH6SfeCRGzkrrJeLBJOjMwPW7L+ojp+WW
 KEUyMkfHpyCQ5pt1RNAKeazOQR3+8hKvi1easppNeG9kBIgbc8
 p4XP8JNvy2xYT//jzwAY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2012, Hiroshi Doyu wrote:
> What about having this driver under "drivers/amba"?
> 
> If other similiar drivers are coming up, it's easy to find rather than
> having this arch/arm/mach-*. There may be some possibility of
> generalization later, then. Also it meets the requirement of no
> "struct xxxx_driver" under arch/arm. Arnd?

I'm fine with either drivers/amba (arguing that it's for a specific
amba bus even if it's highly platform specific) or arch/arm/mach-tegra
(arguing that it's platform code and not actually a device driver even
if it appears like one). If Russell doesn't mind having it in
drivers/amba, I'd say we should go for that.

	Arnd
