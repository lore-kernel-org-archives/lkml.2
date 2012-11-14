Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422761Ab2KNMXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:23:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673Ab2KNMXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:23:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Centralise CONFIG_ARCH_NO_VIRT_TO_BUS
Date: Wed, 14 Nov 2012 12:23:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net> <CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com> <20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
In-Reply-To: <20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
MIME-Version: 1.0
Message-Id: <201211141223.21696.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:dvpN9HUT/64gQF9HbyxnMiLIbrfeAuO9QJZ+0VPsliW
 UF6QLWohINGE+mqDdBFCTy4vPe9MGxIgV4ClEHN9ng+oQH2BdH
 zjK1JdkgeN3dAYgKiv2pR1XHk7qgWSl2I76txGw2CJe0aXQlTc
 e5RP8jmHRt6QmVmfU40+EFqDKNiMMt3avetVZenueCqEORAg8T
 DM/hydDTgcSTwPZ5FOwNY8PYgpmx8RwfGzjd8mEz7SX0UC1w9t
 YqCu9iaSHJ5UZvbXp8MeMqlcPn0D2HSPqHoG3WFpaVWWQARZdE
 2brt9M0aB+VDeFKtJadHejYuAn6wDsl3J4jOXQkRvXVE2kOE93
 grkuS+YIMaHh5OygdYqs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Stephen Rothwell wrote:
>   Show Details
>   Make if easier for more architectures to select it and thus disable
> drivers that use virt_to_bus().
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Very nice, I was recently looking into enabling this for ARM
as well, at least for the platforms that are known to not
need virt_to_bus.

Acked-by: Arnd Bergmann <arnd@arndb.de>
