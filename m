Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2GPOUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:20:34 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:45698 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2GPOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:20:32 -0400
Date: Mon, 16 Jul 2012 16:20:00 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Mike Frysinger <vapier@gentoo.org>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-c6x-dev@linux-c6x.org,
        linux-mips@linux-mips.org, user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Subject: Re: [PATCH net-next 8/8] arch: Use eth_random_addr
Message-ID: <20120716141959.GA12338@linux-mips.org>
References: <cover.1342157022.git.joe@perches.com>
 <14a91278564bb5a263c561a7f1bd10ea6386d90a.1342157022.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14a91278564bb5a263c561a7f1bd10ea6386d90a.1342157022.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:33:12PM -0700, Joe Perches wrote:

> Convert the existing uses of random_ether_addr to
> the new eth_random_addr.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/blackfin/mach-bf537/boards/stamp.c |    2 +-
>  arch/c6x/kernel/soc.c                   |    2 +-
>  arch/mips/ar7/platform.c                |    4 ++--
>  arch/mips/powertv/powertv_setup.c       |    6 +++---
>  arch/um/drivers/net_kern.c              |    2 +-
>  5 files changed, 8 insertions(+), 8 deletions(-)

Acked-by: Ralf Baechle <ralf@linux-mips.org>

Thanks,

  Ralf
