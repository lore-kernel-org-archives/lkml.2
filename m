Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab2BJUbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:31:48 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:42985 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932519Ab2BJUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:31:45 -0500
Date: Fri, 10 Feb 2012 12:31:43 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] pcie: Add support for setting default ASPM policy
Message-ID: <20120210123143.69c95d1f@jbarnes-desktop>
In-Reply-To: <1328282293-16551-3-git-send-email-mjg@redhat.com>
References: <1328282293-16551-1-git-send-email-mjg@redhat.com>
	<1328282293-16551-3-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rnQulsmYqzf.pASpuLzqiIg"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rnQulsmYqzf.pASpuLzqiIg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri,  3 Feb 2012 10:18:13 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> Distributions may wish to provide different defaults for PCIE ASPM
> depending on their target audience. Provide a configuration option for
> choosing the default policy.
>=20
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: linux-pci@vger.kernel.org
> Cc: jbarnes@virtuousgeek.org

Applied to -next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/rnQulsmYqzf.pASpuLzqiIg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNX6vAAoJEIEoDkX4Qk9h2r0P/2f2zwrwnzPAS5K+48zMsiqZ
KSOf75Tfkj1UwkmlE2QwZTgxU56a6qz4NsIy1Kz/m5XclJ3RolCs7Tlr6u1yL5Vg
4R5Co4qz3+HxPlvfLMw/m7g1kzGS+bt3wl7Jb7gP8q8hZGiHcfWL7mFJpE3DagWK
YD1yy0h/6jatXFOUXEbZ/Gevz4+fIsNZWg+oQB+oE42wZwoAY7sdoaO45hYukuBp
vJUbAtvendFdV5SWxBEbjj3cxem41NLAFuOlTmepZSwrAkvMS7qoFFOhrJy1WoEX
Dm4MWTY/AAW1VQKuP70SUkfHgowx2eok8JaZAyK7NVsNeSX+YwIRLlD1JkcTMSq4
QfZ5jIqynubN33u9D5LU1yv2BSLmwtifwV5kyLPXpbhYtbCm+IAJ9Oz5E3UKR9AX
A+UFiJ0dE5Rp1O4DAekLtNYKK5QXWP3MfrqfDK+DAOI3brShKmxxaXPy3PWHQX5s
MjhhzL5Ezv4afdQNZrz1ceokwSN+qm5hrNcDuSJ903YXM5x9zrZkxI0t4gTa5295
7kadddbHqGpj14qtxIuaR9MGaeGwJwUys37dj14Z5Pa9Ykm+3MM7W2Z9inc33tGm
DnSAzNu/slxTMrL+Et1Zc0VHdmXmZgt5WCt9bNuL3xYUSZY8OJIAWSCsIb7kfDEg
aCTeQasc3fW3HDkHJgDV
=3PTY
-----END PGP SIGNATURE-----

--Sig_/rnQulsmYqzf.pASpuLzqiIg--
