Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1BOD67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 22:58:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34600 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1BOD64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 22:58:56 -0500
Date: Tue, 15 Feb 2011 14:58:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [next-20110214] Kernel-modules with unknown parameter
Message-Id: <20110215145849.81116623.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTi=NG+KTGh57oR6Ahq34PohdL5FQFsV+7=4a-J1Z@mail.gmail.com>
References: <AANLkTimM1Tmws46DUyoNGsn+P8WN1XPsRu=L8yPzd=xU@mail.gmail.com>
	<AANLkTikO=5zBCvPbd2MXqgzE_mvnabTtH_e2C5_5bpQv@mail.gmail.com>
	<AANLkTinFOPc+BM8cnPE3SLt7Dc2TFOw1v+bntFu01hpO@mail.gmail.com>
	<201102151030.26956.rusty@rustcorp.com.au>
	<AANLkTi=NG+KTGh57oR6Ahq34PohdL5FQFsV+7=4a-J1Z@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Feb_2011_14_58_49_+1100_A5pRGvMYmour.Xns"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Feb_2011_14_58_49_+1100_A5pRGvMYmour.Xns
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Tue, 15 Feb 2011 04:34:24 +0100 Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>
> On Tue, Feb 15, 2011 at 1:00 AM, Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
> > On Mon, 14 Feb 2011 11:45:59 pm Sedat Dilek wrote:
> >> >> Any idea what's going on? Stephen, Randy noticed the same like me?
> >
> > Dmitry broke module parameters with a "trivial" transform which turned =
out
> > not to be.
> >
> > I wasn't paying enough attention, and let it through.
> >
> >> My damn brain can't understand - looking at the series file in [2] -
> >> why the hell the "possible" patch [3] is not included in linux-next?
> >
> > There are markers in the series file, which indicate what goes into
> > linux-next.
>=20
> Thanks for the explanations, it makes things seen from the
> patch-management side a bit clearer.
>  ( Not sure if the series files was modified in the meantime. )
>=20
> Here for documentation-purposes-only (partially extracted):
>=20
> [ http://ozlabs.org/~rusty/kernel/rr-latest/series ]
>=20
> # NEXT_PATCHES_START
> # MM_PATCHES_START
> # Trivial compilation fixes.
>=20
>=20
> ## for-linus
> virtio:virtio-net-add_schedule_check_to_napi_enable_call.patch
> ## for-linus end
> module:deal_with_alignment_issues_in_built_in_versions.patch
> module:do_not_hide_modver_version_show_declaration_behind_ifdef.patch
> virtio:blk_allow_re_reading_config_space_at_runtime.patch
> # MM_PATCHES_END
> # NEXT_PATCHES_END
>=20
> [ / http://ozlabs.org/~rusty/kernel/rr-latest/series ]

That is how it looks today.  Yesterday, the patch
module:deal_with_alignment_issues_in_built_in_parameters.patch
was also included and that is what caused the problem.

> Looks to me, the FIXUP patch marked with ***** was not really applied
> to linux-next?

No, instead the breaking patch (above) was removed from Rusty's
linux-next series today.

> Also, this fixup patch is no more in Rusty's series file.
> Is that all correct now?

Rusty has a new version of the above patch which includes the fix (I
assume) but it is not included in linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Feb_2011_14_58_49_+1100_A5pRGvMYmour.Xns
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNWfn5AAoJEDMEi1NhKgbse2UH/RhBoyPV2mnQTgb211n10Fu9
vzOmsxYSFAnZxFNpVjOjqvLmf8ZW5i49XX5GRgOuxRamXvh2fY5bdxw3yl+jd5Wg
Cx43z/zv0W09flRrQWRiWYYVBTB4a5jkmRR7N92QEbaUuvfOSTT8mnxFAtJhWqb+
sa/pga17qTqgX3Bxut4P40RkJ5CuXFOlWo071WY0mmFRKYd5bZp3mQmnJkiEQa4d
ogt5VmjLE8Q3glj0tF794JEGfg2JGfrAQ+K0s7/yc6sSu2YZoG/CxQeQjVx2zGDY
/f8iwj1c225nudRdsjCStC5a/mls7KujOOOCw6Ejhq3LAzauUvjJAmelcb343iA=
=eIIK
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Feb_2011_14_58_49_+1100_A5pRGvMYmour.Xns--
