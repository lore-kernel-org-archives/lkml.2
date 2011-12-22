Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1LVBDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:03:55 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50994 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1LVBDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:03:53 -0500
Date: Thu, 22 Dec 2011 12:03:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Samuel Ortiz <samuel@sortiz.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: linux-next: Tree for Dec 19 (nfc)
Message-Id: <20111222120343.32afd5524db3cfe8b3876892@canb.auug.org.au>
In-Reply-To: <4EF28D6A.7080505@xenotime.net>
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au>
	<4EEFA21B.5010305@xenotime.net>
	<1324399181.5354.0.camel@sortiz-mobl>
	<4EF23A1F.60803@xenotime.net>
	<1324500160.5354.3.camel@sortiz-mobl>
	<4EF2569D.1070806@xenotime.net>
	<1324510522.5354.5.camel@sortiz-mobl>
	<4EF28D6A.7080505@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Dec_2011_12_03_43_+1100_O=Eoye=K3b+FTm5j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Dec_2011_12_03_43_+1100_O=Eoye=K3b+FTm5j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 21 Dec 2011 17:52:42 -0800 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> On 12/21/2011 03:35 PM, Samuel Ortiz wrote:
> > On Wed, 2011-12-21 at 13:58 -0800, Randy Dunlap wrote:
> >> On 12/21/2011 12:42 PM, Samuel Ortiz wrote:
> >>> Hi Randy,
> >>>
> >>> On Wed, 2011-12-21 at 11:57 -0800, Randy Dunlap wrote:
> >>>> On 12/20/2011 08:39 AM, Samuel Ortiz wrote:
> >>>>> Hi Randy,
> >>>>>
> >>>>> On Mon, 2011-12-19 at 12:44 -0800, Randy Dunlap wrote:
> >>>>>> On 12/18/2011 11:55 PM, Stephen Rothwell wrote:
> >>>>>>> Hi all,
> >>>>>>>
> >>>>>>> Changes since 20111216:
> >>>>>>
> >>>>>>
> >>>>>> (not new today, just not reported earlier)
> >>>>> John applied my fix for this one. It should be fixed now.
> >>>>
> >>>> Hi Samuel,
> >>>>
> >>>> Is this supposed to be fixed in linux-next?
> >>>> It still fails today (linux-next 20111221).
> >>> Do you have a .config for me to look at ?
> >>
> >> Sure, one of several that failed is attached.
> > Thanks, I just tried this one and it seems to work fine. What's your
> > toolchain ?
> > I'm using: gcc version 4.6.2 (Debian 4.6.2-4)
>=20
> I'm using:
> > gcc --version
> gcc (GCC) 4.5.2
>=20
> so maybe it is something that has been fixed in gcc...
>=20
> Thanks for checking the config.

Well, it would be interesting to know what tree Samuel was testing,
because the fix commit was *not* in next-20111221 due to another error in
the wireless-next tree ...

That fix *should* be in today's linux-next since the fix for the other
build problem is there.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Dec_2011_12_03_43_+1100_O=Eoye=K3b+FTm5j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8oHvAAoJEECxmPOUX5FEB2AP/1YAWL3U+/qLoUTTmn8vTZyX
0ow15ieiwVSbTjyVfsB2aI6mO2rB8p4ILW4eM7q1gX5xjdOFTyl0FfrY9Z14jqNw
Gtp3jPY/BupfLm6Ed8sWP7nBswrg9117GUyepMZyT1h21cNty4f3tQKm+MGgsFi2
l0HvC3UXR7/sMcLHhls9y9BtJyW9GEFdXnmqK7+c/BFSEKGVXD9ceHZBvFM1SDlt
4y1anWIF9SLMjxS+t2Zk2f6APBTNdiqc0cwaf2aXnL5+EtSD9IQJmVUbFaxzsulx
xluSO8oqwOr7yChLyizu3meWfwFa/licvTsvEtsI/OQ/VfzqAx8oGBH+xcHRsWVY
NCuVGlCjHwXEDO3jSWjLOzFpRzFch4jF/b7bwC+vs9+2ABpRFIJEW9xCL90OVcWx
ugJp6Bd/lj2qtuhUR/BBzzUJonV5j9peY1zOaw6DnKcBq0FCgaHzoQUNgv6w2zga
4XvX9xlm+B+Cid7StLRZUKWHeermYWu0Otm9pzwq/dyxC6iNa8AgCdvmf0E9txiT
BCHBe9mxe7VyRLtcPoKmXQBxl9KV7MEJ0LV64djkRxdlZj2k0JX9oYBBa5890dVS
QzUoW5ybtRiFzj733p5hsVlFJ8fB7Dg3nDBJ50ALjgShkTBXg6K5T9yRtknEmLQJ
Epe62lMLvA/idFNEfZlZ
=8s3L
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Dec_2011_12_03_43_+1100_O=Eoye=K3b+FTm5j--
