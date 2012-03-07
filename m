Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab2CGVd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:33:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43937 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab2CGVdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:33:54 -0500
Date: Wed, 7 Mar 2012 21:30:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, sparclinux@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
Message-ID: <20120307213009.GF18787@n2100.arm.linux.org.uk>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org> <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org> <20120307180815.GA27213@game.jcrosoft.org> <4F57AB92.6060907@wwwdotorg.org> <20120307183633.GB27213@game.jcrosoft.org> <4F57C4C6.2070602@wwwdotorg.org> <alpine.LFD.2.02.1203071537130.24151@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203071537130.24151@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 04:03:04PM -0500, Nicolas Pitre wrote:
> Well, I do have a patch series getting rid of ZRELADDR entirely, and 
> AUTO_ZRELADDR would then become implicit, unless CONFIG_PHYS_OFFSET is 
> defined.

Not possible, unless you're goign to also rip out uImage support.

Otherwise, how do we deal with platforms like Versatile Express where
uboot does a funky relocation of data depending on whether the uImage
it's loading is for the low 256MB RAM mapping or the high 1GB RAM
mapping.
