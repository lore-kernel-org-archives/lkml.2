Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2A0SXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:23:16 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:50646 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751404Ab2A0SXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:23:14 -0500
Date: Fri, 27 Jan 2012 10:23:11 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH 18/21] PCI: Fix cardbus bridge resources as optional
 size handling
Message-ID: <20120127102311.6027ea2c@jbarnes-desktop>
In-Reply-To: <1327140517-14811-19-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-19-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I4YBQgV0WXMHr3fJej0LjKC"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/I4YBQgV0WXMHr3fJej0LjKC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 02:08:34 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> We should not set the requested size to -2.
>=20
> that will confuse the resource list sorting with align when SIZEALIGN is =
used.
>=20
> Change to STARTALIGN and pass align from start.
>=20
> We are safe to do that just as we do that regular pci bridge.
>=20
> In the long run, we should just treat cardbus like regular pci bridge.
>=20
> Also fix when realloc is not passed, should keep the requested size.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I'd like to see some testing on this one... Dominik?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/I4YBQgV0WXMHr3fJej0LjKC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIuuPAAoJEIEoDkX4Qk9hnSIQAMsD+A35VK+u91iQPjPEjM99
iXg2Ey6Aph8jJV/As0FsluOEGhOIYsSqPl/zCV8bvAT9RtdcWo7l+LFWs2bFy+gK
A2w+KZH5hBLnFDF3Pr3wIUIsJufpqZhz2z+YtY1qZ8F3qRt3IDX6CMYZcAU38bHK
bh2rT7sY2U3uBNpwcvyObnwMkoMW0WuAOm21oK2vBgJSJ6gEpS00dXn85sJb8GNT
Cg06hN61G0l85kkN26Men1amLurq79BnNJGWEwIJIr+lNQrKJusq7KOL8aCwM0oV
zF0eYGGN9NNYgBex0dxOUSeo/zOCOWcki3k1cNpJcc1e8OS4LP6cz0c96EtD2C6B
ivC8hV83dP2X23qTLKpZSxb08S3F7nUbwUkZd40eNwyFUdWrqkj4mEfr50Rl+1+n
sg7MTxIvoByJAWK0apFBv+BQT8LEfq+1hgn6DagG77kj3UWioadFmT1xIIp7APLR
aPWem9mUMgwoyLTnO1QXsouXC/dJxVCa5q/g2qg+z3sBuSRUfzh+5GDxKY4w8cR1
Al2VTt0PTRRQOduTgzyNhVFalGri6kWnt22kevtaO6sZpDVeIceWv0Sd7TUraa/K
nQK2gJdVdS5Jk/ekrKJ/hciifQLC/0zzQDJ/b23HMQw8AAnp8lHBfH3GUMdPxxyk
udDgfHsFmKI79vNt5WKp
=Gbck
-----END PGP SIGNATURE-----

--Sig_/I4YBQgV0WXMHr3fJej0LjKC--
