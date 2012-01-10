Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2AJDBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 22:01:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48547 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab2AJDBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 22:01:49 -0500
Date: Tue, 10 Jan 2012 11:12:22 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Michal Marek <mmarek@suse.cz>, Jon Loeliger <jdl@jdl.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Russell King <linux@arm.linux.org.uk>, linux-c6x-dev@linux-c6x.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        microblaze-uclinux@itee.uq.edu.au, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linuxppc-dev@lists.ozlabs.org, linux@openrisc.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] Kbuild: Use dtc's -d (dependency) option
Message-ID: <20120110031220.GC23362@S2101-09.ap.freescale.net>
References: <1326134295-15547-1-git-send-email-swarren@nvidia.com>
 <1326134295-15547-2-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326134295-15547-2-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 11:38:15AM -0700, Stephen Warren wrote:
> This hooks dtc into Kbuild's dependency system.
> 
> Thus, for example, "make dtbs" will rebuild tegra-harmony.dtb if only
> tegra20.dtsi has changed yet tegra-harmony.dts has not. The previous
> lack of this feature recently caused me to have very confusing "git
> bisect" results.
> 
> For ARM, it's obvious what to add to $(targets). I'm not familiar enough
> with other architectures to know what to add there. Powerpc appears to
> already add various .dtb files into $(targets), but the other archs may
> need something added to $(targets) to work.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Though I did not look into the patches deeply, I know the problem very
well and it annoys me a lot.  It's great that we have patches to fix
it, so

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn
