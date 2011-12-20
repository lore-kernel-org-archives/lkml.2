Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1LTLTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:19:53 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:39542 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab1LTLTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:19:45 -0500
Date: Tue, 20 Dec 2011 13:19:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH 1/3] usb: musb: fix pm_runtime mismatches
Message-ID: <20111220111935.GE31842@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323990310-11905-1-git-send-email-felipe.contreras@gmail.com>
 <1323990310-11905-2-git-send-email-felipe.contreras@gmail.com>
 <20111219081137.GF3146@legolas.emea.dhcp.ti.com>
 <CAMP44s2pbLRHB2ko9t-zQEpTFw=TaCS9b_qRmvAobgxeJ9WrCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Content-Disposition: inline
In-Reply-To: <CAMP44s2pbLRHB2ko9t-zQEpTFw=TaCS9b_qRmvAobgxeJ9WrCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2011 at 10:20:09PM +0200, Felipe Contreras wrote:
> On Mon, Dec 19, 2011 at 10:11 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Dec 16, 2011 at 01:05:08AM +0200, Felipe Contreras wrote:
> >> Properly call pm_runtime_put() afer pm_runttime_get() on errors.
> >>
> >> Untested.
> >
> > sorry, but I'm not applying untested patches. I need someone to give a
> > Tested-by.
>=20
> I'm pretty sure most people don't test the exit paths, but fine, don't
> apply them. Who needs power management anyway.

if it wasn't tested you can't claim $SUBJECT makes PM magically work.

--=20
balbi

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8G9HAAoJEIaOsuA1yqRE6PAP/3AywDvJuY0QyfM4zGGCbNKE
A2kxxAaUhaRMuqM/k3s/8gS+oHzOtCfe4WgYB+Vlsb6f3o4Fh0TMgFB4Nz6ZbLxC
iUGt+h+s4xfWRqXarUb9cpYjiYPdZ/686TQFJD4LEcGp0jm+0WipV0TYmid2nj3c
kWPxJkHQRYL/rFz08Pw66M2F1oW8hnhojwxNyGqP76CvoLwW967HAVbTNpllmZj7
cggqAGdnxfKRfuUnNNsw11vJBQaIy1RpPOhSgHpgCpmUcdNQ0IqmDbltQx/Sm0TW
8WAlmmtcK1101IB+ejSf4kkXBW9qBsY594Kv1soyalt3AdwgafQ8Zg0NxGqE/4MA
x67h8dUgho3YsvLqhtoKXiCX9XxcL+cJtp6huy2qCrMA15b1cLakTEUF9MvO7UKV
omEVk2SZRbSMYGwF4K33tP155bF73YztrwQjjZjnLkijnqgq0UDvhOhIznd8Lr1K
LoqBn9ktmkFqvyMTuO82QU656J04ysAxBGYdeHU3G3f9wvH7aL11Y5h4ixJvLkPb
vYdXh43Z66IPVBqzqI2xkmcvNXzmmuyK316nOW1RljyKZTLDlVTo6oPO69kQq7EZ
7Q6vikPoXEvnggcabBAl7z2YSfgHF34vwtYPV0Zpp5dZR9QXJH+LO2Avn05b18/8
IkFcEQt8VEcrWdstJKqe
=zZeH
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--
