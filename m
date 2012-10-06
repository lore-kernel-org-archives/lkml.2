Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2JFHDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:03:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2JFHDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:03:43 -0400
Date: Sat, 6 Oct 2012 09:03:30 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/2] ARM: pci: Prepare for Tegra PCIe controller driver
Message-ID: <20121006070330.GA4842@avionic-0098.mockup.avionic-design.de>
References: <1348127025-29461-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <1348127025-29461-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:MBFG6jm0/Ior5Wd4PEiCqOaWB0WVB1IKpjMrwXS/AEi
 vL6cQQNxqoGjHam3KDwHJ5t5sRrj+5dHXaPa2UJES+/JyyGomv
 iP0VDQCtcMcc6v4f0eo2v9hesqrGUhM/jUtiMDXvTbTjsiBg+2
 Q3VOdBLOMeh1bpTRp6zcNSDr5boMxBZBIdtESer+irQq8T1SRh
 P3p0cwYc0TE2781ZtjlDtP2W0ULgetDWP/X/APZlqrb+pemtiP
 B4aSn90iNBDH9fjnjbU90DpujcMEqik0TKtMh68uxTrnqLwSSd
 DGO34TwJKFNmznyBe9kZM43/U1uJi7zSrbNHBqiOyZcbLYd9kZ
 NCdvs3nBtD75+0bPDr9zllRKwV2w1/G8u18/3EKk5jHXP0mLWf
 s/kWfa4sZFjhE73SIWEXl7xSwl+bz2H3YE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 20, 2012 at 09:43:43AM +0200, Thierry Reding wrote:
> Hi Russell,
>=20
> These are two patches I've been carrying in a larger series that
> converts the Tegra PCIe controller driver to a proper platform driver.
> Since the complete series didn't get much feedback, I've begun to post
> smaller subsets in an effort to get them merged more easily.
>=20
> The first patch in this series removes the __init annotations from the
> pci_common_init() function (and pcibios_init_hw(), pcibios_swizzle() as
> well as pcibios_init_resources() because they end up being called from
> the former) to make sure that they stay around after the init stage.
> This is required because the Tegra driver depends on regulators that
> become available only very late during boot and uses deferred probing to
> handle this situation. It turned out that this postpones the PCI bus
> initialization until after init, thus this patch.
>=20
> The second patch is used to pass per-controller or per-host-bridge data
> to the driver, such that it can be associated with the corresponding
> bus. This is also required by the Tegra driver in order to pass a
> driver-private structure to the PCI bus (or more precisely the
> pci_sys_data structure associated with a bus). It is subsequently used
> to obtain the root port private data given the corresponding PCI bus.
>=20
> Note that v3 is pretty much the same as v2, except that it is rebased on
> linux-next and contains the removal of the __init annotation from the
> pcibios_init_resources() function which is only in linux-next.

Hi Russell,

have you had a chance to look at these yet?

Thierry

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQb9fCAAoJEN0jrNd/PrOhZLEP/2lcjO7SdKcH8OdpHjKhs5Ii
lZXc/wJfHYIKLPEgPKwAHCA6wkCwuGx/VUotLkQRN7LqS/sHNsUHpQad43zBy2xV
GIHXmRH+/U9yGOwS0W1HkfLj8MmKCu2P7W/7gaTNZTU6Zxcoek141ZzfIcHQFZtB
ayTz7XrW2lg0C5A6snGvP+YpjlXAxf57iRXMe3nWtpETZY9RrELnraDwj/cxRi1I
oYntOMMBpUR8Fh3044HN+pa+XlO+dlEtABfjgK+8qxc1GhC1IyZKp8/C+Mn7ii5o
SHXXO3XYYkVaY0mp5G6ysUKxoK6p0UI043JPA9oz2c4I60xVvbkinNov94Brk1pZ
nVQbWmnqBqcIbXLYDVM6PU7qIYdtwR0iE//0jGEYggTXieCyGKmdpsXpltnP4C3U
U3grvmOYDeFhiY9kQuLnI5ImFR8Z1GDd1OyI3/nZ0g/0vGQOqKk+OvCTMUOZY5FR
juGtVCIEDcwThwQaPWSpMu+KRDqaisdSJEvbmz/RnadKKgK3tXNLk5YdJBrs5sfn
R/sGwrBGkJ4Xyd8jgwgWhTGQDz2U02koyu3Nn3s14oUVN+o0xbzIPteo9je0rQLl
oUorgsV2+D7uH8u0gguvouDzXAgpJ5uZ9UkxhMGSL+sVA+dMnkJFDAyBorMWDaHc
01wish0wPK7IFE9sRy4A
=HdMe
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
