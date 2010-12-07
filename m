Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0LGA1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:27:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45262 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab0LGA1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:27:44 -0500
Date: Tue, 7 Dec 2010 11:27:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: build failure after merge of the acpi tree
Message-Id: <20101207112734.4d1bef8c.sfr@canb.auug.org.au>
In-Reply-To: <20101202112239.c7d05518.sfr@canb.auug.org.au>
References: <20101202112239.c7d05518.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Dec_2010_11_27_34_+1100_LR/T+JjRj1ft0.YO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Dec_2010_11_27_34_+1100_LR/T+JjRj1ft0.YO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Thu, 2 Dec 2010 11:22:39 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the acpi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> In file included from drivers/video/output.c:25:
> include/linux/video_output.h: In function 'video_output_register':
> include/linux/video_output.h:49: error: implicit declaration of function =
'ERR_PTR'
> include/linux/video_output.h:49: warning: return makes pointer from integ=
er without a cast
> In file included from drivers/video/output.c:27:
> include/linux/err.h: At top level:
> include/linux/err.h:22: error: conflicting types for 'ERR_PTR'
> include/linux/video_output.h:49: note: previous implicit declaration of '=
ERR_PTR' was here
> drivers/video/output.c:84: error: redefinition of 'video_output_register'
> include/linux/video_output.h:44: note: previous definition of 'video_outp=
ut_register' was here
> drivers/video/output.c:114: error: redefinition of 'video_output_unregist=
er'
> include/linux/video_output.h:51: note: previous definition of 'video_outp=
ut_unregister' was here
>=20
> Caused by commit 16d21716c8849c3283d1b9e590e6fe8d1966f4b7 ("ACPI: video:
> fix build for VIDEO_OUTPUT_CONTROL=3Dn").  See Rule 1 in
> Documentation/SubmitChecklist.
>=20
> I have used the version of the acpi tree from next-20101201 for today.

I am still getting this failure.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Dec_2010_11_27_34_+1100_LR/T+JjRj1ft0.YO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/X92AAoJEDMEi1NhKgbsnr4H/2A9dWuqDBg/sbrd5Kl6SQ2l
Kv7I+zPEusDPePhPfWQdS4Xd8zIjsNlxf2APmXB+lYsKjI3EG0ZNg5QoDnUjB4tt
1YusvHrgYysMq7HpaXQDlpbCmTVoxURnQU3QSQ6PywBe1RO4+pHTHWAClrzWPcUf
LEp9j0MmpWacDZi7jJgLdgqWZF6Z07V8nuxGgsP0guHReL8sro50sTbGZ+suoN3C
WLE7UxA52DfxgWEa5/QYcDvxwB+f4nIXGrCGKAiUOez6Hqo8jY/PldPrcWlQLiJD
WIKLkvRvkRWkN9VH8vpTqmrJ876mllz3kDqlMy6mv0TJDajfMGAJwg/WL15uhh0=
=rguc
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Dec_2010_11_27_34_+1100_LR/T+JjRj1ft0.YO--
