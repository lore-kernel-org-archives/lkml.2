Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab1INOIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 10:08:15 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47052 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab1INOIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 10:08:07 -0400
Date: Thu, 15 Sep 2011 00:07:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Temporary location for hid, apm and trivial trees
Message-Id: <20110915000759.44ec63c0f9a3d68239886de5@canb.auug.org.au>
In-Reply-To: <alpine.LNX.2.00.1109141520450.13109@pobox.suse.cz>
References: <alpine.LNX.2.00.1109141520450.13109@pobox.suse.cz>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Sep_2011_00_07_59_+1000_qbiaEtriYV6W8o0s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Sep_2011_00_07_59_+1000_qbiaEtriYV6W8o0s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Wed, 14 Sep 2011 15:24:32 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wro=
te:
>
> temporary locations for hid, apm and trivial trees until kernel.org=20
> reappears, are
>=20
> 	git://twin.jikos.cz/jikos/hid
> 	git://twin.jikos.cz/jikos/apm
> 	git://twin.jikos.cz/jikos/trivial

I am assuming the for-next branch of each.  However, fetching the trivial
tree fails with:

fatal: The remote end hung up unexpectedly

I will switch to these tomorrow (assuming that you fix the trivial tree).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Sep_2011_00_07_59_+1000_qbiaEtriYV6W8o0s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcLU/AAoJEDMEi1NhKgbsxHgH/is4YMy3w1vhvsQvubqb2Mf3
IpcpQfMKcTjAEAYD8sQpNpfu5aIkODo7x4v0zHNlAXvcAZdS4C81UiD3o7O75Cgp
8+91yfbhUvbsuukMd98OO32FJu+fO7o409RVXQz/vBSARyvnVJBFf1V7FuKFSdtL
XKHXm9ILYnRQuH/Aj2vcK3b9uql7BACXhZICNuy9xFqeLU3jSPfvV9vLFWtN7TcE
AS2UMX4BUzOiTk1ulr9bbc/Zq8m9zuIQmbKteC1hxvobmsS32X+s2Mc7wIGck8hb
01VN75VrmblnZ/CluNE4LC8/yr0WbZP2rwXdutajooWejj4LdpGI/ls2MCF/XAk=
=H+R1
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Sep_2011_00_07_59_+1000_qbiaEtriYV6W8o0s--
