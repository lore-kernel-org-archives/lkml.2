Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab0JSGXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:23:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54503 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab0JSGXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:23:39 -0400
Date: Tue, 19 Oct 2010 17:23:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ruslan Pisarev <ruslanpisarev@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gorskin Ilya <revent82@gmail.com>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 v4l-dvb tree
Message-Id: <20101019172331.89476ae0.sfr@canb.auug.org.au>
In-Reply-To: <20101019171233.9f3e1dad.sfr@canb.auug.org.au>
References: <20101019171233.9f3e1dad.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Oct_2010_17_23_31_+1100_QfyEfRIGRwW+hXb7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Oct_2010_17_23_31_+1100_QfyEfRIGRwW+hXb7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 19 Oct 2010 17:12:33 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/cx25821/cx25821-audio-upstream.c between commit
> d6a0215fc954bd16a21bad94a3292f080d9f6f04 ("[media] Staging: cx25821: fix
> braces and space coding style issues") from the v4l-dvb tree and commit
> bb59a4c539140592723e806e852ee171da0eb3eb ("Staging: cx25821: clenup
> warnings found by checkpatch.pl tool in cx25821-audio-upstream.c and
> cx25821-audio.h") from the staging-next tree.
>=20
> Basically different versions of the same patch.  I fixed it up.

Fixed conflicts in drivers/staging/cx25821/cx25821-audio.h as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Oct_2010_17_23_31_+1100_QfyEfRIGRwW+hXb7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvTljAAoJEDMEi1NhKgbsbx8H/0lrVX6E1KH6wPvqtQRVDEuW
gfPMjU/yMEzJoj1Ea65ICSDuu8YHxedMJnhinjAwNh5uoqhbp1K/6S16ngX/BzBx
k1+1pZrWuz7Qn0aKoJqAwNZirkY/tpmHOR2JjrCkrSbYf/XfF0YExe77/3YNc0z4
k5c3ZBzk9MQiYonC1OJmEyOFfqSsAXbPbp2GOGezBGKKr/I3O96Ix9vSaw+X1IUS
Vfp+XNs1KMpq3KFYd+x3p2d5d/x7KVJyCWNikG8ue2uijXAOP6kwluY+ucoMRBmB
vajhE8Ckn56t5MF500uGmXCLxpAMYJfAObZNSBVV+HpiW/NDA2Jjtd8VF/3Dp6Y=
=WDF/
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Oct_2010_17_23_31_+1100_QfyEfRIGRwW+hXb7--
