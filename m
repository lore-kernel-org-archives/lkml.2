Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab2KZKN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:13:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48686 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2KZKN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:13:28 -0500
Message-ID: <50B340C5.1060308@atmel.com>
Date: Mon, 26 Nov 2012 11:13:25 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the sound-asoc
 and pincrtl trees
References: <20121126205312.46fb3f816e1e95ba8cbb5049@canb.auug.org.au>
In-Reply-To: <20121126205312.46fb3f816e1e95ba8cbb5049@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/26/2012 10:53 AM, Stephen Rothwell :
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in 
> arch/arm/boot/dts/at91sam9263.dtsi between various commits from
> the arm-soc and pinctrl trees and commit 7492e7ca0f95 ("ARM:
> at91/dts: add at91sam9_wdt driver to at91sam926x, at91sam9g45")
> from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no
> action is required).

Good fix. Thanks.

Best regards,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJQs0DFAAoJEAf03oE53VmQ6QwIAJFOQ58HXL8RTJMii7T8Qvmj
hP0BVyICTYIJNymKiYk9R2RHXUhz3iwjSGCNYKtnaqcY3G3DQGy2uwwqyGjqTMzB
n0W8s1z3rMr1facVzwlbsVHg/Y+K4a8dJPiwvskUVbRPctKkWYvjdQ+Ruv6v+F9u
a2qqMM8zRNTgZhJvDT3mT4hjLnwRIH3CRckvHKQlDwoxE+Kbhvn3wM2uc9P/bCCX
oVtx05SrCU129RRpztPkvyFzDnuoduznaB9CauSzmKpgzT0PF1yZkDNXgJUCoUXr
jpSRLQg167/yk/2Sufz7pbSB9v10FEO54SavkdbIg00ktKTqc4CIdpKE5Wy1Jws=
=S3HZ
-----END PGP SIGNATURE-----
