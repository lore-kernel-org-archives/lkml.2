Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2JYXuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 19:50:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54782 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2JYXuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 19:50:19 -0400
Date: Fri, 26 Oct 2012 10:50:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Stefani Seibold <stefani@seibold.net>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: build warnings after merge of the akpm tree
Message-Id: <20121026105015.729a0762249b29bbed39dc65@canb.auug.org.au>
In-Reply-To: <20121025152337.7f14919d.akpm@linux-foundation.org>
References: <20121025142854.1924363d6a607004f918ac63@canb.auug.org.au>
	<20121025143044.d21e2c29b16ee2005f93a371@canb.auug.org.au>
	<508948de.01dc440a.58ed.ffffff17SMTPIN_ADDED@mx.google.com>
	<20121025152337.7f14919d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Oct_2012_10_50_15_+1100_dW=owF6sLjijBYa9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Oct_2012_10_50_15_+1100_dW=owF6sLjijBYa9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 25 Oct 2012 15:23:37 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Anyway,
> include-linux-kfifoh-replace-open-coded-type-check-code-with-typecheck.pa=
tch
> takes the kfifo typechecking from "too strict" to "far too strict", so
> I'll drop that patch.

I have dropped it from the akpm tree in linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Oct_2012_10_50_15_+1100_dW=owF6sLjijBYa9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQidA3AAoJEECxmPOUX5FE8WsP/3YTVM0bU1F+fQikI095frof
OWA5AafbJKBhUWre0xeuBsOe9PVIDBC8MjQk3r296FejKCbbLZwPpMQg8vucixFT
zk91eaKFfRU2KgAivot6KpxRC+PR2o+V9Ga9j7MiZgULeKNmke/Iq5YXxKL5AzcY
SnE2RBejJrpycqKf5la3M1Qf7NCLdpYKIM2ExYgIWWaADFk9mXAyU1ih6IRa1Ffx
gV6jKWFYBMyZYFJq01sd9N44WIm1VxnhPkCE+S2nIaEEWDYOe8ygFKtQLw3ae4dy
j0e7dXi+H2RzQXCcjWOUvhNY3hFm6m+Fpd7Avv96K08fg3bqH621E5hdHLCOvVe5
2KgQrDoHbzfWZsY8VKrXxqExFYLhhs14j4Vk2pfF0haMgrlC3OEv6ESov7A7I8eh
AUlofFTUD23gvz2uQ7+BYeKbzDiN/iCEsPG2XqcPsFyGLv3ujYDIv4IvS4s01YN4
RzOJOmJkcXzaVgZMwDhVcU0P51CAkotJmUEkliDIak6o4LoUVw1e9IGEuAA1HuA1
s4ffTkBig6rYbU27pyTsgoYprk0wxRgqSOeR3Ov5yw7MjcxfELWCnRANf77O5ktJ
oIwVppwUzBZ1DoBWOU1xErtheEWTB4/TxDdydiImVGDnrxAFg3F01/9WldFIL6fG
Ji4pdUu25tHh1NdpZiBd
=3ToN
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Oct_2012_10_50_15_+1100_dW=owF6sLjijBYa9--
