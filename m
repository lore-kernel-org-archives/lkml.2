Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0L3BUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 20:20:19 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:44240 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab0L3BUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 20:20:16 -0500
Date: Thu, 30 Dec 2010 02:20:03 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Message-ID: <20101230012003.GA2665@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
References: <4D1A8200.4010609@lwfinger.net>
 <20101229195440.GD5838@darkside.kls.lan>
 <4D1BD2B0.4020101@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <4D1BD2B0.4020101@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 29, 2010 at 06:30:40PM -0600, Larry Finger wrote:
> On 12/29/2010 01:54 PM, Mario 'BitKoenig' Holbe wrote:
> > I did 2 things:
> > 1. I (manually) reverted 84c164a34ffe67908a932a2d641ec1a80c2d5435 from
> >    2.6.37-rc7: The crash disappears, b43 is useable.
> > 2. I added 84c164a34ffe67908a932a2d641ec1a80c2d5435 to 2.6.36.2: The
> >    crash shows up as with vanilla 2.6.37-rc7.
>=20
> Please show the output of "egrep "B43|RNG|RANDOM" .config".

CONFIG_B43=3Dm
CONFIG_B43_PCI_AUTOSELECT=3Dy
CONFIG_B43_PCICORE_AUTOSELECT=3Dy
CONFIG_B43_PCMCIA=3Dy
CONFIG_B43_SDIO=3Dy
CONFIG_B43_PIO=3Dy
CONFIG_B43_PHY_LP=3Dy
CONFIG_B43_LEDS=3Dy
CONFIG_B43_HWRNG=3Dy
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=3Dm
CONFIG_B43LEGACY_PCI_AUTOSELECT=3Dy
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=3Dy
CONFIG_B43LEGACY_LEDS=3Dy
CONFIG_B43LEGACY_HWRNG=3Dy
CONFIG_B43LEGACY_DEBUG=3Dy
CONFIG_B43LEGACY_DMA=3Dy
CONFIG_B43LEGACY_PIO=3Dy
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=3Dy
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_HW_RANDOM=3Dm
CONFIG_HW_RANDOM_TIMERIOMEM=3Dm
CONFIG_HW_RANDOM_INTEL=3Dm
CONFIG_HW_RANDOM_AMD=3Dm
CONFIG_HW_RANDOM_GEODE=3Dm
CONFIG_HW_RANDOM_VIA=3Dm
CONFIG_HW_RANDOM_VIRTIO=3Dm
CONFIG_SSB_B43_PCI_BRIDGE=3Dy
CONFIG_CRYPTO_RNG=3Dm
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_ANSI_CPRNG=3Dm
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=3Dy

> It should not matter, but please try the attached patch.

It will surely not matter: if CONFIG_B43_HWRNG would not have been
defined, hwrng_register() would not have been reached in the dump from
my first mail.

If you really like me to try that patch, I'll do so when I'm awake again
and will then answer you that nothing has changed :)


Mario
--=20
It is a capital mistake to theorize before one has data.
Insensibly one begins to twist facts to suit theories instead of theories
to suit facts.                   -- Sherlock Holmes by Arthur Conan Doyle

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTRveQxS+e2HeSPbpAQL0tQf9Ekz0OUbWeeWEQSUKPgI/0uZPXENbFLKy
Fn/mvh1FILdBULDmi4ZLrQt4cp1bQOBC7G7P+1Mln6WetOK+y+LF9kqDNVw8arvT
gEOKjI2hLEDc3JXQjP+Ns1w2qUhoPZSbcAObhVU4Ui81bqE1bDoWQ1FmUmKEc5pf
cafMQTL2HUjfdoVEEKFIZDhEace+lofBBpId+4ELJ+ujhJFgjjuajvM3yC1SNNpl
65fdX8uPjHp8MBCZcmHAIjZlcSkOs9uQBsVbgpTIlE5MuPW7loKDnRfSsqBCKBk8
gI2w+6+JPXENFVvLVog4hwGrfX7sX7XnzBLrJQjcweH1OnuPf1IuDQ==
=lpiQ
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
