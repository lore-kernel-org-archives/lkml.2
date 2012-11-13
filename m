Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2KMIsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:48:33 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:13738 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2KMIsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:48:32 -0500
Message-ID: <50A2095D.3020306@atmel.com>
Date: Tue, 13 Nov 2012 09:48:29 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, Greg KH <greg@kroah.com>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        <linux-next@vger.kernel.org>, Michal Nazarewicz <mina86@mina86.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
References: <20121113152029.9bcfc18a4bca8dc53a033a86@canb.auug.org.au>
In-Reply-To: <20121113152029.9bcfc18a4bca8dc53a033a86@canb.auug.org.au>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/13/2012 05:20 AM, Stephen Rothwell :
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/configs/stamp9g20_defconfig between commit 77614e025061
> ("arch: Change defconfigs to point to g_mass_storage") from the usb
> tree and commit 2484575268e2 ("arm: at91: drop machine defconfig")
> from the arm-soc tree.
> 
> The latter deleted the file so I did that and can carry the fix as 
> necessary (no action is required).

Yes. Thanks a lot Stephen.

Best regards,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQogldAAoJEAf03oE53VmQqTgIAKUtqhwnXt8Rm1x+ERPiPLno
VhFc1ZPgiPUepSecHMFPCcWtgwLBg6HUFXg4muM7kpf1hvMtAB6CmpasjceV8g0N
KMFC4GrRi6y0dp59DpBUa1gB87i4gpliqmroO3YGu8iGDHGowDBV8HsfmNpLmGTJ
WmdjDzpWE3hfLjNl5F0qnkI1cqDAyWrQwE9cNIFpzY93GfKkVTjdxiKIf6PprJl8
SIicUbeHV/lrNyusEZw0CcNa89qtKCovdBN7Yk64xwyyTnLprxq/Sr30WaFx4npf
A6vdUeCsKL3glD67rD7MUYXZ5KS0pLOuxIVJvvlugbOCwrNDPrZd6NZhqFkgMh8=
=Fpq2
-----END PGP SIGNATURE-----
