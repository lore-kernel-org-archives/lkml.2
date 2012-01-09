Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab2AITmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:42:19 -0500
Received: from jdl.com ([208.123.74.7]:35515 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933288Ab2AITmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:42:11 -0500
X-Greylist: delayed 2574 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jan 2012 14:42:10 EST
Message-Id: <E1RkKQN-0000nM-2c@jdl.com>
To: Stephen Warren <swarren@nvidia.com>
cc: Michal Marek <mmarek@suse.cz>, David Gibson <david@gibson.dropbear.id.au>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        Russell King <linux@arm.linux.org.uk>, linux-c6x-dev@linux-c6x.org,
        Arnd Bergmann <arnd@arndb.de>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        microblaze-uclinux@itee.uq.edu.au, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Mackerras <paulus@samba.org>, Mark Salter <msalter@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, linux@openrisc.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] dtc: Implement -d option to write out a dependency file
In-reply-to: <1326134295-15547-1-git-send-email-swarren@nvidia.com>
References: <1326134295-15547-1-git-send-email-swarren@nvidia.com>
Comments: In-reply-to Stephen Warren <swarren@nvidia.com>
   message dated "Mon, 09 Jan 2012 11:38:14 -0700."
Date: Mon, 09 Jan 2012 12:58:27 -0600
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: -1.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This will allow callers to rebuild .dtb files when any of the /include/d
> .dtsi files are modified, not just the top-level .dts file.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This patch is against the Linux kernel's copy of dtc, but it applies to
> upstream dtc with a couple of trivial conflicts. I can post a version for
> upstream dtc as well if desired.

If it does go upstream into Linux proper, we should
definitely have it in the main DTC repository.
So if you would, please send me a path that applies there.

Thanks,
jdl

