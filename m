Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2ASPIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:08:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55668 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab2ASPIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:08:23 -0500
Date: Thu, 19 Jan 2012 09:08:18 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Dustin Kirkland <dustin.kirkland@gazzang.com>
Cc: Li Wang <liwang@nudt.edu.cn>, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] eCryptfs: infinite loop bug
Message-ID: <20120119150818.GA18263@boyd>
References: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
 <4F16E4BC.5080100@gmail.com>
 <526922120.05125@eyou.net>
 <12011909443668a7a65ff897afc93db177848236f08f@nudt.edu.cn>
 <20120119084836.GA29477@boyd>
 <CANT6BaOqXwut5iA2ADO_2avW2kCSV0WL_6=3Vv1zdFNXrnXjPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <CANT6BaOqXwut5iA2ADO_2avW2kCSV0WL_6=3Vv1zdFNXrnXjPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-01-19 08:03:57, Dustin Kirkland wrote:
> On Thu, Jan 19, 2012 at 2:48 AM, Tyler Hicks <tyhicks@canonical.com> wrot=
e:
> > On 2012-01-19 09:44:36, Li Wang wrote:
> >>
> >>
> >> Hi,
> >> =A0 Thanks Cong Wang for the kind reminding regarding the patch format.
> >
> > The commit message still needs some work. But there's no need to drag
> > out the process for a fix like this, so I'll rewrite the commit message
> > and reply to this email with the cleaned up version. Let me know if you
> > have any problems with that. You'll still be credited as the author.
> >
> > For future kernel patches, please see "15) The canonical patch format"
> > of Documentation/SubmittingPatches and "5.4: PATCH FORMATTING AND
> > CHANGELOGS" of Documentation/development-process/5.Posting for more
> > information on how the commit message should be written.
> >
> > Also, your email came across in base64 encoding. I'm not sure of the
> > reason for that or how to fix it.
> >
> >> =A0 We did notice that the total_remaining_zeroes need be revised as w=
ell,
> >> and the start_offset_in_page, num_bytes need not be revised (always sm=
aller
> >
> > Yes, size_t will work fine, as Linus confirmed.
> >
> >> than PAGE_CACHE_SIZE, even the huge page size is supported,
> >> the 4G page size is not present in the current world?)
> >> but we forget to include the revision for total_remaining_zeroes, so h=
ere comes the patch.
> >
> > I really appreciate the patch - thanks!
>=20
> Tyler,
>=20
> Is this the problem behind our long standing
> tor-download-on-ecryptfs-hangs-cpu bug?
>  * https://bugs.launchpad.net/ecryptfs/+bug/431975

Yes. Unfortunately, I had missed the infinite loop on i386 part, as I
was testing/developing on x86_64.=20

Tyler

>=20
> --=20
> :-Dustin
>=20
> Dustin Kirkland
> Chief Architect
> Gazzang, Inc.
> www.gazzang.com
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPGDHiAAoJENaSAD2qAscKFmQP/iiUEqAkLphBqQTtTIABBbq2
Cbg3UwMq8ewGrFG2BsUN8tdKPr086AyJUCcls41F+IT/p8S6wqAtMOtRSY0fU5Zb
y2/y01NU4jeI5z83VTcrx0WY1UT6Oof2UHcGc/QKpWlrf3jUIMdZKSn4MLQ7qGyp
y7EAxBoyWkIpX0jWEWOARO6do7T5IGqt15Aj52hwxPo3GcD755SdJPFbbiObLFFP
pXXgnw/6YLADHaLKatuav14xSeO8YvQ4PHX69nE6VJORv0ny3GkegNdFc3AXlTZ7
aq7L/kEN31InYF/4ZiOXZ6yHsnlshzhqatJZffBOuKom9h6ZG54gjNCW1z80D4cX
DlWNhIxtWxEoVf88jBqUyfAR3aGPQ92wGZYELYnQuT7LBHdfS36kf1Gm+R39TF1d
U6im5qX/Gc13L4P5bGNSUUhf+GaB4iFFDRPQjp2Vw2ak2/XLlea+RhTJlsPQkZCF
dGONOSYzdpK6r9F+T+Ww2CJrDT/909L0CTMI4fyTQKPvwXjzdld+UWzSvVx7cAwR
2bvojbn9IVyoMt1KZDTWRhIeOGI9ce/QRYcycRzdlibRB8CL89xHCPru87g1su+n
LXFvA65bUI1R5j6nym8tutQE6yvUEybPgyF+/bnsL5xVwCrvnMMwCuR8GnplOS0o
ZAaM+qFMGTjHXCgPfDnB
=Ttsz
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
