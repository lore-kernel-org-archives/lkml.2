Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2GPM5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:57:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab2GPM5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:57:46 -0400
Subject: Re: [PATCH net-next 8/8] arch: Use eth_random_addr
From: Mark Salter <msalter@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Mike Frysinger <vapier@gentoo.org>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-c6x-dev@linux-c6x.org,
        linux-mips@linux-mips.org, user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Date: Mon, 16 Jul 2012 08:56:36 -0400
In-Reply-To: <14a91278564bb5a263c561a7f1bd10ea6386d90a.1342157022.git.joe@perches.com>
References: <1341968967.13724.23.camel@joe2Laptop>
	 <14a91278564bb5a263c561a7f1bd10ea6386d90a.1342157022.git.joe@perches.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1342443401.2880.2.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 22:33 -0700, Joe Perches wrote:
> Convert the existing uses of random_ether_addr to
> the new eth_random_addr.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/blackfin/mach-bf537/boards/stamp.c |    2 +-
>  arch/c6x/kernel/soc.c                   |    2 +-

Acked-by: Mark Salter <msalter@redhat.com>


