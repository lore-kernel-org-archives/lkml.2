Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3AGXWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:22:36 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59197 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3AGXWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:22:35 -0500
Date: Tue, 8 Jan 2013 10:22:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: please cleanup the cpuidle tree
Message-Id: <20130108102227.19d4102cb1ddf516ad4082d1@canb.auug.org.au>
In-Reply-To: <50EB5636.4080705@linaro.org>
References: <20130108092751.4bd60a67280e284369553c18@canb.auug.org.au>
	<50EB5636.4080705@linaro.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_10_22_27_+1100_1lPbRDd.V7lSfBqX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_10_22_27_+1100_1lPbRDd.V7lSfBqX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Tue, 08 Jan 2013 00:11:50 +0100 Daniel Lezcano <daniel.lezcano@linaro.or=
g> wrote:
>
> On 01/07/2013 11:27 PM, Stephen Rothwell wrote:
> >=20
> > All the commits in the cpuidle tree have been included upstream before
> > v3.6-rc1.  They were rewritten before being merged upstream and so are
> > now causing merge conflicts in linux-next.  Could you please reset the
> > head of your tree
> > (git://git.linaro.org/people/dlezcano/cpuidle-next.git#cpuidle-next) to
> > be somewhere in the tree that yours is merged into (pm or Linus').
>=20
> Sure. I believe it is done now.

Yep, thanks.

> > Alternatively, if you are not using it any more, let me know and I will
> > remove it from linux-next.
>=20
> I am planning to do some more cleanup in a very near future. So I prefer
> to keep it untouched for now.

No worries.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_10_22_27_+1100_1lPbRDd.V7lSfBqX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ61izAAoJEECxmPOUX5FEMpUP/1dy4y/YXq/CzrvnxR9KW2XW
4iW1jRUymLXoqVXTcXVk4/FVxgynXmlxGZA8CzOCPc0dWTXxvqYauOAo/7ZqPGK9
nZYuIptxbdMdJMjKnJjXr68B1r1WQPSbZ8iiY2ZKmaPdrwb3CskVdyOSR04adYlx
FxolDZZgCTpZcDsJnq/rFrud7t5XerWNA1t61yP8NXe8TafF/LHZATqCk08/EQ2B
sSz1vRQdb8uBqVQmNUxFJnSFZ0FOZI4Wss2b2WZyv4jKG274ykDAsOu5VbCjrXU+
aba8EMu11H14LS7ZmS0XR5FSO3BwWTLnOwdLZvP8Yp6qym1ZluEwJ+Zlrd2qsaQo
SR0+q54LfPYMX/Sv1QFJiR16J7jS/LjQpTjVAAXo3Eb+T4mMgxDxzwPqa8vwrgKo
hFveeiG4XKJkSKjyvZk5FRasRqt/2IsPoJrZEFIGl4moR0aHQ76Qm+TmBDy3FgiP
7KqKqbd93CplLvgRMJQOt2bFpINZFt0pk9zlzC9lVIuK0aK6GLQMRg2iHx7zu3m5
1PO/Vb5C0b3cMNLJd8m2h3nGbGKzUZhpXxB1QFa/V5RJGrmS+0SU3qYhiza79lrw
+uZW3RqjKm47SyKSP7Wu0OR0+HuJkywH0fh5yIqTcewvsJBnWmPNUGy+um/XYDxs
jlf+VC/b4KdkYmkGJbZh
=vtrz
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_10_22_27_+1100_1lPbRDd.V7lSfBqX--
