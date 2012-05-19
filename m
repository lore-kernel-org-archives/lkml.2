Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2ESUyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 16:54:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40811 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756816Ab2ESUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 16:54:04 -0400
Date: Sat, 19 May 2012 21:54:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq_domain: Standardise legacy/linear domain selection
Message-ID: <20120519205400.GB16590@opensource.wolfsonmicro.com>
References: <1337428920-7674-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120519202258.D9B903E03B8@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <20120519202258.D9B903E03B8@localhost>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 02:22:58PM -0600, Grant Likely wrote:

> I'm looking at killing the legacy mapping entirely which will push
> changing all the users anyway.  I'm going to hold off on applying this
> one for a day or so until I'm sure of what it will look like.

I take it you're going to replace the legacy mapping with an equivalent
thing, though, so the interface is preserved for boards?  In which case
it'd be more like replacing the linear mapping with a new mapping type
that can also be used by legacy users I guess?

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuAhhAAoJEBus8iNuMP3dVI4P/jYVxi9pCCD5wlkfCkwoWBpj
L/lyUgzB3a9GXYrz6dDvkl1PysPn0rto8y0s4oJE/+JMupVmzVDNVBmbJSeO4vxA
jshNU+NOQ/QniPYrH/CUZL35LQIca0uO7PpgX5jfscTaIPRNYZR2cZAirVprkqBc
LWZzdwVEd53QmT921LqZVEvWEHjnKj4uCT88lrza2fS7x9VURApMqseUJx8FYNg0
N++tT0x82/VmqHfebQfcJ8UcmNR5y3ZolKINpu2sSj8zeScLtZJVJdssXFGDJi0N
99Bil+8a3MN36niCm4aWPULQinrnzCsgIeimJOzoeoo7PyMiTrkB3eoBXLKakwIi
iqTWe6QuebtXrZ7d0TXk8mYNzdszsQP82EvbxSanL9TIcNYAwkf6e1KyMU3v7X+y
e4PxGie0VMSKmquMnRQfh6aNJqMoWqGHBm09jo2BGdKtL07Y1HuJaU9XCaybM1AF
8GDL1Jt8VF5AU+ngI0uoeF1BUZxi0Hd3Ik6bg3MFWb3Ar+47wAb5yTX7e36Dmnb7
IfbM9YrmkNagIzoQmi6epef8zJHUwH1Zj3Eo5pnOmQvwiWHsxA4aKTeAGYc8lSvy
YYBLA3F58AKHIjswEiTh205LxVk3NCPyc9+kMyJN5G+krX+iuZmJno0J0wFAbcqY
DmrkFmfPvsKU/RZZcbSA
=pcFB
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
