Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2KMIrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:47:52 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:13568 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2KMIru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:47:50 -0500
Message-ID: <50A20932.5000409@atmel.com>
Date: Tue, 13 Nov 2012 09:47:46 +0100
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
References: <20121113150631.e316da9049b2ce6685aa729e@canb.auug.org.au>
In-Reply-To: <20121113150631.e316da9049b2ce6685aa729e@canb.auug.org.au>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/13/2012 05:06 AM, Stephen Rothwell :
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/configs/afeb9260_defconfig between commit 77614e025061 ("arch:
> Change defconfigs to point to g_mass_storage") from the usb tree and
> commit 2484575268e2 ("arm: at91: drop machine defconfig") from the
> arm-soc tree.
> 
> The latter deletes the file, so I did that and can carry the fix as
> necessary (no action is required).

Absolutely, thanks Stephen.
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQogkxAAoJEAf03oE53VmQtxgH/1YpP1OvRv2A8kMAK5zanKHO
J/AanooWZIFrnceRCC5SddeCV667wPoiLiucOuAFQpz5CC0XgSUNRWLEfOQ+x859
y0FXw/Nrbl1OvvFScH4Nm9JeXtoMRpX6t2opTZTjZXy+QeGL6GlNUZx1MvBFOWE7
EbIlWNuf/zNmmxAg5+Wd9du0KIm0xYo5zLYG1isHYA3pEpWVq5bf99V+ym6xg9sL
xFQRxqxyYSJMEhbszIrMszp38ZzE3oDCqWQAFABzQpiTab8+7ykJlP7Rq5RXTfL+
mvd1AtyJjMTbp5Szpa06EDOpNTPaiAuzHEAfwTCHGzxxeo2M4hiOy7nXej1qhCo=
=RVPo
-----END PGP SIGNATURE-----
