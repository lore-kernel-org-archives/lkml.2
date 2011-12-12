Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1LLUxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:53:17 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:47064 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753738Ab1LLUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:53:15 -0500
Date: Mon, 12 Dec 2011 12:53:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (pci
 tree related)
Message-ID: <20111212125309.54a47973@jbarnes-desktop>
In-Reply-To: <0207C53569FE594381A4F2EB66570B2A018EFB78F3@orsmsx508.amr.corp.intel.com>
References: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au>
	<CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
	<20111208072412.e9cf00f9bcdbc4450fe2d2d4@canb.auug.org.au>
	<CA+8MBb+n_y=BGQihjGujAq7=cUwpdOTP0-7uRoftFeXouD=QHw@mail.gmail.com>
	<CAErSpo4V4Nhga5q7wHSiLmr4LubV4Sy+8gMZuob+163ZOHr__Q@mail.gmail.com>
	<0207C53569FE594381A4F2EB66570B2A018EFB78F3@orsmsx508.amr.corp.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0+Q3updznu1azjrq_1vFuGQ"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0+Q3updznu1azjrq_1vFuGQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 9 Dec 2011 12:02:48 -0800
"Luck, Tony" <tony.luck@intel.com> wrote:

> > Sigh, I'm sorry.  Attached are the incremental patch to fix this, and
> > an updated version of the original patch.  I'm not git-smart enough to
> > push it this time (the box where I normally do that is down at the
> > moment, along with my notes).
>=20
> Bjorn,
>=20
> Thanks - the incremental patch works great.

Thanks, just applied it (by hand) to the linux-next branch.  Hopefully
I didn't botch it...

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/0+Q3updznu1azjrq_1vFuGQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO5mm1AAoJEIEoDkX4Qk9hWwwQAIo9Wz9I4FLk3GXtR9QZDhv5
+NsbtPA2VtvX55Um6YXD10NDOkYEWAqGxn1pAGDk2Hrj47MUwVap/Zw8ZNrgXdI5
LRtMLF+kkORdRTD7B8GM7iMm7rXCPr3rksQtrYVo7sDFfzBSkYF+6Tbi6tJ8d7Fr
LenyQSoxFOBBkbtUEcgshTSrCzTXU/X4T7Plytsgaynh0+qbJ+VizwQPJDBQWdsR
PkUgzC2KS5u9+sx9AfSsW1ojjdSPfNElKUru8mrA5RD5lcBzHQFVe8s32GIkrNOa
hE3nWOUqs7t3m9eGNnomklGkQjwVGEoqxgqjv7GzuqsYXS9WUmIvpK642Z1zrZaT
3qCzxNHyqRu1h0x7o8wOWsDbUjrb9qtrlwz24j0wOXsL6d5cX6AN2AaZquw3u4su
ssEo1fAU7FNCdr9oTcKCf8L3uskmeS4SyRei2/gR182zkHPZpTdiAdOG/+/v57In
QGBg50C4C0tZJ+jwLfh7bjXJaIyJkwXFtlhxb9fB6f05cSuYdIc7yg9XPrZaT8RD
ww13wViyydtoJMtvvKfrVeuGTPXpgslbZ3iVaYyPP+ucTj5eIN0XariJP4IOX4O8
VqXChIwaZXDHlmZt/27yJTgIHgDAdPEYsc2Hz6W5m5A1XtuBEHejwseqlvCIrgJh
vSGpKzjCd356vuQWF/AN
=8rMd
-----END PGP SIGNATURE-----

--Sig_/0+Q3updznu1azjrq_1vFuGQ--
