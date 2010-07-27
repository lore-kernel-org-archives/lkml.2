Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0G0ABv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:01:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59123 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab0G0ABt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:01:49 -0400
Date: Tue, 27 Jul 2010 10:01:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
        Dave McCracken <dcm@mccr.org>
Subject: Re: linux-next: build failure after merge of the final tree (xen
 tree related)
Message-Id: <20100727100137.c9ec453c.sfr@canb.auug.org.au>
In-Reply-To: <4C4DE64C.9070004@goop.org>
References: <20100726152908.951a95b7.sfr@canb.auug.org.au>
	<4C4DE64C.9070004@goop.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Jul_2010_10_01_37_+1000_NDkhPZOr+/PhG_+t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Jul_2010_10_01_37_+1000_NDkhPZOr+/PhG_+t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

On Mon, 26 Jul 2010 12:47:24 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wr=
ote:
>
>   On 07/25/2010 10:29 PM, Stephen Rothwell wrote:
> > Hi all,
> >
> > After merging the final tree, today's linux-next build (i386 defconfig)
> > failed like this:
>=20
> Both these build failures should be fixed in upstream/xen now.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Jul_2010_10_01_37_+1000_NDkhPZOr+/PhG_+t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTiHhAAoJEDMEi1NhKgbsHMUH/jh5hnfncj8hkR8u5rWvGimu
uGH3avtgqa5USHibgj/Mi8418JnMuq3joAnfTYhtJa7AnnQe8wcTjpjtvuQKsjj9
/B0eHWugQGz9Ott8+7bLXzJ8a52Ccy1VJULaieUXR7T4ybbWKgyo0pcCYJBjg+++
klekRzsjVdlsG4Gfeb+mkzAhaF3mvkxsxc0EmJCY2qnMWfAjB/raVyDzG6C7+AwR
jK2WzhTajPImDyiSdJJAzfqKyVspHPac993eCQNliiRQD4t77/HIDnc7SMP/peBt
sEiVEq+lDYtQpte1Ak7hCwUcoAvgsxc/WtfUvwtx+RuMiGMVZFuADthNtE+V5rQ=
=Hkqd
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Jul_2010_10_01_37_+1000_NDkhPZOr+/PhG_+t--
