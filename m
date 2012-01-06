Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab2AFV0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:26:10 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:34369 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751714Ab2AFV0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:26:09 -0500
Date: Fri, 6 Jan 2012 12:10:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Jones <davej@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Dell Studio 1536 needs pci=nocrs to boot.
Message-ID: <20120106121051.76243fc7@jbarnes-desktop>
In-Reply-To: <20120106175757.GA16807@redhat.com>
References: <20111230193704.GA2874@redhat.com>
	<20120101145354.GA1791@elte.hu>
	<20120103093020.0cbcd735@jbarnes-desktop>
	<CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
	<20120103180020.GA15014@redhat.com>
	<CAErSpo6S19rznjbkos3LPk8K9GK=kFUr9+OqRfeZ72TiJpj35Q@mail.gmail.com>
	<20120106175757.GA16807@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qhYoeVJYG9rX++t+3fVmp0r"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qhYoeVJYG9rX++t+3fVmp0r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jan 2012 12:57:58 -0500
Dave Jones <davej@redhat.com> wrote:

> On Fri, Jan 06, 2012 at 10:32:14AM -0700, Bjorn Helgaas wrote:
>=20
>  > > There's at least one more dell (Seems that entire 'studio' product l=
ine
>  > > is affected) that I'm waiting on DMI data from.
>  > > Also a thinkpad that I have a patch pending for.
>  >=20
>  > I think we should drop the Dell 1536 blacklist entry from this patch
>  > (adding set_nouse_crs() itself is fine and may be needed for other
>  > machines).
>  >=20
>  > The patches here: https://lkml.org/lkml/2012/1/5/402 should cover the
>  > Dell 1536 issue as well as the Dell 1546 and any others with the same
>  > BIOS defect.
>=20
> Sounds good to me.

Ok just did some patch mangling in linux-next.  After a quick build
test I'll push it out and you guys can make sure you're happy with
things.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/qhYoeVJYG9rX++t+3fVmp0r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPB1VLAAoJEIEoDkX4Qk9hcKQQAIOT+I2YaEy2oERcpaci0uG1
ui5iVYcllLoXHWLrPSxRMn7s5fm78pPUM5SpLW54FMpzXO/xCZH91wKlP9KCX4D8
moaAqDE2IO2FK/A31tOVd4aZB8td8ueUfVM+AAb1IzuZuUb8uX5+FSPk1wstY4LK
kKTjBFrDUYDknId4we6oKR1Kcb1FQIyaKSDpIeWjNr9dWoy1OTomsFX7F3zJjC8E
WtaPiWfspwaRZW4ByK4u3Z/sfn3lYg6lRdz8G1HdRgPTyiUAWW7NyEVSND3fyBMl
x4Erp8BABI1gD0jElOVg2qaL71W6Jiy5TNJEEDDjiq1H6ETbx9JNaDOB+68SvxNM
gs13+Gm/GUfXVutt6/uCpsN0vjKrk4RwD5Px9NzoUS6b+87U/cJdxfET50laj1nw
npkpogLvgVY6FH6g9S1zgmBPAw66E6u2ycqIPyOREV/c51EYywNYQi3FdfyrJcqA
APb7ubvhHRTtDibgieUK71dkvfqam81VYuz7nenBwHEUEK7ufO/nD+cH+Gp8UO2h
G8+o9sLvn685UqAJgl8NeVo3R7tBBp7CdaPM4a8vcWwgF4j/TfVRnVHtc6x1M/w7
XNy3R/yJn/Hc8GbnOOgGkWWKkmLjUq6IPNe/NLwQmA7qxpbilampD647Z5QtymjP
Fk9OtWg5Rab1f20c5Qfm
=FdUe
-----END PGP SIGNATURE-----

--Sig_/qhYoeVJYG9rX++t+3fVmp0r--
