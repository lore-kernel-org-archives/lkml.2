Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab2BXWhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:37:48 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:60600 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932298Ab2BXWhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:37:46 -0500
Date: Fri, 24 Feb 2012 14:37:36 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] PCI: Move out pci reassigndev resource alignment
 out of quirk
Message-ID: <20120224143736.683b73e7@jbarnes-desktop>
In-Reply-To: <1329370832-2253-4-git-send-email-yinghai@kernel.org>
References: <1329370832-2253-1-git-send-email-yinghai@kernel.org>
	<1329370832-2253-4-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/odGpxMs883QyWKWI/TvlTQs"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/odGpxMs883QyWKWI/TvlTQs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Feb 2012 21:40:31 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> That looks like abusing quirk framework.
>=20
> calling it directly in pci_add_device. or do we have good place for it?
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/odGpxMs883QyWKWI/TvlTQs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSBEwAAoJEIEoDkX4Qk9hsdkP/RcG6uzoHNVH9k9Z52zzf9is
f6bqafdmntkzcIrSx2MBtcBAZKSlyBDe7ZZXNfJe/DrMNsTmglvO6HLqKQA6x/lk
asaKHFO3AgU4WQ6Ew9FuqTECSkQgKwjCs7ulzt29h3KZNSVLlqB8eKLnd7JcAAJd
MFYsJdK/fUxdpztKirMsQq8iWMB+6BoWPf5ihle48ZzR8uvlWbA+HAZBeW48UVBa
g9fpXTc3ArnLtBeVwC9DHFog9cdYRrFliSjBAp+X7VpwJOts6gQft1nmQdU3qeDT
irCrTICAziwpXDF96b3Eh5uznjZT77VHp39lf4xOOW20wBUV12mIRtYVYL91Tqk1
5hkcX9xESig/RjwGLxXKoudR5IzdXReoq4pI98m9DECOCy7/WufWWI0YRD9qRRG5
QfKpfep4jn+XPPZ2zIozJ8tPXV+anIlIJUpjimjR2uEIVUmDHWDXPihzBgulC45U
YwGW+8ITHnUKa7p9J+REINhqv4kgMwx0beVYLiXpVfdQ7Q8Qx0yQZTS7dArQ2Ixb
dVKFXOqYRGlWVmLAsB1xuzSm1sUy+xhI5sYJnDfqmzchPtaZu36EWepxiHsV11D2
7Ror+3uEY3sDbTK0VbVpyXJGX4MWgBrWGYnQ6dm2QVxtKWAi+NC5oMK7B0dIkGHa
I5aydzIwTyL+d5lLvG8B
=wyA4
-----END PGP SIGNATURE-----

--Sig_/odGpxMs883QyWKWI/TvlTQs--
