Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2KSA5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:57:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2KSA5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:57:43 -0500
Date: Mon, 19 Nov 2012 11:57:28 +1100
From: NeilBrown <neilb@suse.de>
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Paul Menzel <pm.debian@googlemail.com>,
        Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Message-ID: <20121119115728.2d175646@notabene.brown>
In-Reply-To: <20121109195610.GA2928@jtkukuna_gentoo_sb.jf.intel.com>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
	<1352460945.4387.7.camel@mattotaupa>
	<ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com>
	<20121109225025.13a846ca@notabene.brown>
	<20121109195610.GA2928@jtkukuna_gentoo_sb.jf.intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0_dUvfKNSfqQzIhJuwJEBGx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0_dUvfKNSfqQzIhJuwJEBGx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 9 Nov 2012 11:56:10 -0800 Jim Kukunas
<james.t.kukunas@linux.intel.com> wrote:

> On Fri, Nov 09, 2012 at 10:50:25PM +1100, Neil Brown wrote:
> > On Fri, 09 Nov 2012 12:39:05 +0100 "H. Peter Anvin" <hpa@zytor.com> wro=
te:
> >=20
> > > Sorry, we cannot share those at this time since the hardwarenis not y=
et released.
> >=20
> > Can I take that to imply "Acked-by: "H. Peter Anvin" <hpa@zytor.com>" ??
> >=20
> > It would be nice to have at least a statement like:
> >  These patches have been tested both with the user-space testing tool a=
nd in=20
> >  a RAID6 md array and the pass all test.  While we cannot release perfo=
rmance
> >  numbers as the hardwere is not released, we can confirm that on that h=
ardware
> >  the performance with these patches is faster than without.
> >=20
> > I guess I should be able to assume that - surely the patches would not =
be
> > posted if it were not true...  But I like to avoid assuming when I can.
>=20
> Hi Neil,
>=20
> That assumption is correct. The patch was tested and benchmarked before s=
ubmission.

Thanks.  I've queued the patch up.
>=20
> You'll notice that this code is very similar to the SSSE3-optimized
> recovery routines I wrote earlier. This implementation extends that same
> algorithm from 128-bit registers to 256-bit registers.

I might notice that if I actually looked, but it all starts swimming before
my eyes when I try :-)
If both you and hpa like it, then that is good enough for me.

Thanks,
NeilBrown


>=20
> Thanks.
>=20


--Sig_/0_dUvfKNSfqQzIhJuwJEBGx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKmD+Dnsnt1WYoG5AQJ0JQ/+Mqt/mNZF95htpa6Gy1yIxeriasuxSIDT
nNCCkIFk4sWyPWvEf4/aPHGmsvzpzY0/fSkxV3RYbi5tVDD53gGNV0p3qAmFIppN
ioWFvXzRRIbsc3cmNUtKlyfXbeIa/NAyfNQ2duHIc5M0oZyxf/upsVaWfAbF5A8X
X//TDMn3WD5XqzldtFSotusiQf1OzO0z0LR5sqKvgITZYLHlAtfnCa+Bob0aau7m
rTsuLxEBtO4qA5Fx4GIKI9O7Zt6Iz9o/LJlOECugEkz3jUuYP7m2Q3x0dEGkN3gQ
l1F1VhbJtMh4v2cV4247ZTYLRFYU8DRHzfVp/gpZ27AJ5rN4GIf2YuKD5W5pq9jO
vEelCIw9vlQgx46RGbosRU1teDc5hSWQLBdVBdcsnEemf3CaODyJCNStG0xIhDS4
lY43hrIxbyICc4bK//vYVqXm43kO1CShwCf8sQ/i+xucdqLKox3n24EQq6e8HuGR
4Mh30TH00SGpTWoZDLkYry6y90kueVG0qF5htKKWubHRZ2SfZRs6BTXL+t89md2m
vthGd2HhenmLPEN9Kv7fPB0mcLwi+3PM2TBbAXcanW2tqW2dGl03BCKwAgQWdC5s
H/woM4P6FqiX/pvi3GPTQ4WVBe+7sKVBk7KDiP7GnNxiv473ul5VeeyReiXQPFvZ
CLXGNujeV/o=
=hSnv
-----END PGP SIGNATURE-----

--Sig_/0_dUvfKNSfqQzIhJuwJEBGx--
