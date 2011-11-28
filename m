Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1K1TLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:11:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:65399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1K1TLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:11:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Date: Mon, 28 Nov 2011 19:11:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <20111128105633.8a8c06afce3cdccb1ce0d7b7@canb.auug.org.au>
In-Reply-To: <20111128105633.8a8c06afce3cdccb1ce0d7b7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281911.36341.arnd@arndb.de>
X-Provags-ID: V02:K0:o20PkXhcX1JCyj/8h4E4ADrZRN1HrSApuQT6FK/Qy3y
 NY7BxyG0sJNLqTJGXclWInIhnzdc+X3wyEWEiDuNBk1iDbxXOJ
 u+O+E30oVWOwKKzHEeA92/oNzGwr85uOmnqmcOAm0nkjES/8ep
 vph1+yhbjiFV2bFTyv0l73SoGrZKx2Ve5hSUq4PhzlzwEAweu2
 hqHn+XYZ2kOozBJ3m0ko+lYKWRxdhu6znBLYbgAVxrJQ+91N4z
 QD29K3Ll1Gcfrpol/6MX2eXfac/bkSTxcuoLy5771nKdk+ydRz
 G8HDk97CXZLKIsOJwYf12ub+ua0UdosFJBzB4pEXAzbgNFREJN
 bYZsuTqZNAlqo+FOgk4k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 November 2011, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/plat-omap/include/plat/common.h between commit 4e65331c6bb4
> ("ARM: 7159/1: OMAP: Introduce local common.h files") from the  tree and
> commit 13662dc5b177 ("ARM: OMAP: HWMOD: Unify DSS resets for OMAPs") from
> the arm-soc tree.
> 
> I did the obvious fixup (see below) and can carry the fix as necessary.

Your fix looks technically correct, thanks!

Tony, I believe what you actually want here is to move omap_dss_reset
into mach-omap2/common.h, right?

I guess that I will at some point pull in the first commit from
Russell's stable devel branch, so I can do that fixup instead.

	Arnd
