Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab2CGSUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:20:38 -0500
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:50618 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759523Ab2CGSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:20:36 -0500
X-Greylist: delayed 37235 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 13:20:36 EST
Date: Wed, 7 Mar 2012 19:08:15 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mike Frysinger <vapier@gentoo.org>, nico@fluxnic.net,
        linux-sh@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, sparclinux@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
Message-ID: <20120307180815.GA27213@game.jcrosoft.org>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
 <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12000967108974324557
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:30 Tue 06 Mar     , Stephen Warren wrote:
> This allows the user to use U-Boot's mkimage's -T kernel_noload option
> if their arch Kconfig allows it, and they desire.
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> The next patch enables this new CONFIG_ALLOW_ option for ARM. I assume
> that some other architectures will also be able to enable it, but I'm
> not familiar enough with any to know which.
I'm going to repeat. I don't think any impromevent here.

with no specific kernel load address the uImage for is useless/

And this no the job of the kernel to build a boot loader specific boot image
format.

And the uImage format here is called the legacy format where now U-Boot
support a new format based on DT format.

Will you plan to add it too?

no sorry I don't think it's the right way to go.

On X86 we boot zImage simply. The new uImage option to do not specify the load
address add nothing more than just boot a zImage for kernel point of view.

Further more on server the vendor will use grub mostly (even on ARM) and will
expect to boot a zImage.

Best Regards,,
J.
