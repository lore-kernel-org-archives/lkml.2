Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0CQTmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:42:14 -0400
Received: from virgo.iok.hu ([212.40.97.103]:47841 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab0CQTmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:42:13 -0400
X-Greylist: delayed 1065 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 15:42:12 EDT
Date: Wed, 17 Mar 2010 20:24:24 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Suspend/hibernate wireless regression with 2.6.33 kernel
Message-ID: <20100317192424.GA27414@genesis.frugalware.org>
References: <20100317015113.4e833e1c@boulder.homenet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="glG7QM0/F4Gfd30i"
Content-Disposition: inline
In-Reply-To: <20100317015113.4e833e1c@boulder.homenet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--glG7QM0/F4Gfd30i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 17, 2010 at 01:51:13AM +0000, Chris Vine <chris@cvine.freeserve=
=2Eco.uk> wrote:
> I have a Lenovo S12 (Ideapad) netbook with a BCM4312 802.11b/g
> [14e4:4315] wireless device.  Although this works using the PIO option
> in kernel 2.6.33/2.6.33.1 (not with DMA) using the in-kernel b43 driver,
> and also works with the broadcom proprietary wl driver, it breaks after
> a suspend or hibernate. Attempts to bring up the wlan0 interface with
> 'ifconfig wlan0 up' after suspension or hibernation results in the
> following message (although nothing is revealed by dmesg):
>=20
>   SIOCSIFFLAGS: Unknown error 132

I just wanted to mention that I can reproduce this issue.

Same HW (Lenovo S12 Ideapad), and I can reproduce with b43 and wl, on
2.6.33 and 2.6.34-rc1 as well. It works fine on 2.6.32 for me, too.

Thanks.

--glG7QM0/F4Gfd30i
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuhLGgACgkQe81tAgORUJZZlgCghs9A0iiul4A3D3voO+gMdJJN
1KIAoKDEx20R8r+1o490s9d9dRZvjrae
=VY3z
-----END PGP SIGNATURE-----

--glG7QM0/F4Gfd30i--
