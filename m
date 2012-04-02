Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2DBAD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 20:03:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53858 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2DBADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 20:03:54 -0400
Date: Mon, 2 Apr 2012 10:03:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 00/11] Fix up more asm/system.h fallout
Message-Id: <20120402100341.1b231afd6aa7efb1cb0c8af0@canb.auug.org.au>
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Apr_2012_10_03_41_+1000_GnJ5yR0QtSzz2yBC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Apr_2012_10_03_41_+1000_GnJ5yR0QtSzz2yBC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Sun,  1 Apr 2012 16:38:36 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> Like others, I was surprised it didn't get a soak in linux-next
> before being merged, but I guess what is done is done, so lets
> try and limit the fallout from having any wider of a commit range
> than it already does.
>=20
> It is all system.h stuff except for three things.
>=20
>  1) an avr32 patch I'd created but the avr32 guys hadn't got
>     signed keys yet, so I might as well get it in here along
>     with other similar build fail fixes (the atmel one).
>=20
>  2) A cosmetic fix to the device.h changeset from me earlier.
>=20
>  3) A trivial warning fix to an arch/frv specific file.
>=20
> I'm going to queue this up in my feed branch to linux-next
> so we can start reducing the number of build failures from what
> we had on Friday.

Thanks for all this.  Please feed them to Linus as soon as sensible i.e.
after you get some feedback from the affected arch maintainers etc.
Maybe you should repost some of these with more cc's on them.

I look forward to less blood on the ground in today's linux-next
builds :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Apr_2012_10_03_41_+1000_GnJ5yR0QtSzz2yBC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPeOzdAAoJEECxmPOUX5FEivEP/0SgGQvo1PSCjF7ASM0vRXNi
KIMu0jvnG889WPslxmpDuk/kf67+LSEXy77gBIMC4hib4KifErCjSJ1/7t8QjRTM
nOJETEGZtaH//OYhqd8MlTwqQF12qO8TN/ztEZM00suD7hZS0tLcpAcexQPcoB3k
IRvONEr6SRdEl3B+YTrVhavAdymC9+fSRDIT9kP8VbYN1Gm6omV/lo1gAA/1/sso
sxUyBDRZU8g2ykvU8qcqUyIZuOFsNs6jUUelK1/ZI74qiJ1AC9EkSAEfpCGPp4dh
/Mxp9tCMmlTvdf+VQdWqLAuYnRwQOaLcWNFsjgvhWBkW9HS5xWzYlnTnAiuc4Wph
8jWMgSWwyKkRrxVSyVVHl46SkGDM5eaO79JdNMgZoyPAgJV/KMfc34oG2sA3tIIs
7DuqGvQ7cN1Rin0s/Q0K4qcw5+NKNuvera5k4WGLjutWAAqUFp/unHNrIQLw8+Fs
eAojEJBBPMBqRx5JkR3mSLy0YcwZuKpY85Uc7gdTekOXrDAXJAKoDrx+vdyRsoxI
npXAZXmS3meupaxCYE+uUm7SWiLS6FZFgw4vUvRDMFuDKLm2TwVq61VTyNkE2ljg
Buv1+R22ep6t6aapNIwrZUz1mgwd3BMzdQoTenxn3JHQ0I31Zi6xapgHAyylJo5+
0qyk46Cv76NdPsbuXIpJ
=45+X
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Apr_2012_10_03_41_+1000_GnJ5yR0QtSzz2yBC--
