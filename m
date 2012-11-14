Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422975Ab2KNOYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:24:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49519 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422661Ab2KNOYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:24:15 -0500
Date: Wed, 14 Nov 2012 16:17:42 +0200
From: Felipe Balbi <balbi@ti.com>
To: Xi Wang <xi.wang@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Felipe Balbi <balbi@ti.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-geode@lists.infradead.org>
Subject: Re: [PATCH v2] mm: fix null dev in dma_pool_create()
Message-ID: <20121114141742.GC24736@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1352097996-25808-1-git-send-email-xi.wang@gmail.com>
 <50A2BE19.7000604@gmail.com>
 <20121113165847.4dcf968c.akpm@linux-foundation.org>
 <50A3313D.1000809@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Content-Disposition: inline
In-Reply-To: <50A3313D.1000809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--E13BgyNx05feLLmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 14, 2012 at 12:50:53AM -0500, Xi Wang wrote:
> * drivers/usb/gadget/amd5536udc.c (2)
>=20
> Use dev->gadget.dev or dev->pdev->dev for dma_pool_create()?  Also move
> the init_dma_pools() call after the assignments in udc_pci_probe().

Makes sense to me. Do you want to provide a patch ? Make sure to Cc
myself and linux-usb ;-)

--=20
balbi

--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQo6gGAAoJEIaOsuA1yqREJesP/20t0otDuiBsJNFqKYzBMWtZ
I3q5ceyFe3cU4ZTdTwZ5zBnRhpbge11Os0pKAPsUJZSn3U9R6qDdE7gonCXorV0B
UfZ5ao7EaG7CQ/m0Xfh/V0EXEMlFKHQQTSu8HBkxzvr+4SZLs566OO36ehMt7tP/
4BZ1o18vTkCWLeCOWbS1H7qiL8KjG+jRQcWXmD9zHlXafShBOMAXTb9UHO0T/WCf
F5KICQYxWTPs8//9m3rJ63Dkmvzd7UvycgaZx9MVCig4N3ptP7XXlyHmrCIdfbcq
ww6OnRr10QO+kGJMAw5MVtpUPC2+OR07zkhpF3SkTyWY/qaILzo5RdO3i0eyTgqF
722bR1x1DkcIK7zfHNgwcyw13OAyj1PK50oGoBze9c1nbS3UmhpG4gXGFY0otCri
tLgevxfSgLyDuRWE5xOG7rWl8DHZJKOlKvt3+q26/rTHPVIm85W5xh+SmEOR3+Qn
p3/PuCzRIHmHO6HdBM4qfcjtgeQJWLtxcly9TGROlYxTnOAKB22A49trFlY7DrwT
rPmb4HC50+zJ8CFYBs0wvxd9Z69ufGoj/jYaYmUqrC6seHl7iB3EL7/uFBji9CKB
PkZ3tj14xwsQ02aW1werNUgbgexT4nqH5HHiYZtIg4hFdqbKey4A+Gxbk8j1Wwph
d1WLxFPzOaNovMA0262m
=slHS
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
