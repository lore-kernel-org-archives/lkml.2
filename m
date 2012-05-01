Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2EAUOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2EAUOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:14:16 -0400
Message-ID: <4FA04413.2030400@redhat.com>
Date: Tue, 01 May 2012 16:14:11 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [Patch 4/4] tools/selftests: add mq_perf_tests
References: <1335894655-11398-1-git-send-email-dledford@redhat.com> <674e3954fdc921d2ef34be5686092da4d5302e54.1335894230.git.dledford@redhat.com> <20120501125345.a3ac48c9.akpm@linux-foundation.org>
In-Reply-To: <20120501125345.a3ac48c9.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigADF70F504B2E2E6A55A0B9AB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigADF70F504B2E2E6A55A0B9AB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/01/2012 03:53 PM, Andrew Morton wrote:
> On Tue,  1 May 2012 13:50:55 -0400
> Doug Ledford <dledford@redhat.com> wrote:
>=20
>> Add the mq_perf_tests tool I used when creating my mq performance patc=
h.
>> Also add a local .gitignore to keep the binaries from showing up in
>> git status output.
>>
>=20
> hm, this code sends checkpatch berzerk.  I do think that selftests code=

> should match regular kernel coding - after all, kernel developers are
> the ones who will be reading and modifying the code.

Fair enough.

>> diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/te=
sting/selftests/mqueue/mq_perf_tests.c
>=20
> hm, I didn't have <popt.h>.  On RH that's the popt-devel RPM.  On this
> Ubuntu(ish) machine it's libpopt-dev.

Yeah, I didn't want to throw any sort of high level requires in there,
like rpm dependencies or apt dependencies.  I could get the rpm stuff
for Fedora right, but I would have just screwed up the rest.  So a user
just has to manually make sure they have the right libraries to run this.=


> On an x86_64 build I get these:
>=20
> mq_open_tests.c: In function 'main':
> mq_open_tests.c:295: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'rlim_t'
> mq_open_tests.c:296: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'rlim_t'
> mq_open_tests.c:311: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'rlim_t'
> mq_open_tests.c:312: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'rlim_t'
> gcc -O2 -lrt -lpthread -lpopt -o mq_perf_tests mq_perf_tests.c
> mq_perf_tests.c: In function 'open_queue':
> mq_perf_tests.c:299: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'long int'
> mq_perf_tests.c:300: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'long int'
> mq_perf_tests.c:301: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'long int'
> mq_perf_tests.c: In function 'perf_test_thread':
> mq_perf_tests.c:441: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'long int'
> mq_perf_tests.c:456: warning: format '%d' expects type 'int', but argum=
ent 2 has type '__time_t'
> mq_perf_tests.c:456: warning: format '%d' expects type 'int', but argum=
ent 3 has type 'long int'
> mq_perf_tests.c:459: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'long long unsigned int'
> mq_perf_tests.c:461: warning: format '%d' expects type 'int', but argum=
ent 2 has type '__time_t'
> mq_perf_tests.c:461: warning: format '%d' expects type 'int', but argum=
ent 3 has type 'long int'
> mq_perf_tests.c:464: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'long long unsigned int'
> mq_perf_tests.c:468: warning: format not a string literal and no format=
 arguments
> mq_perf_tests.c:495: warning: format '%d' expects type 'int', but argum=
ent 2 has type '__time_t'
> mq_perf_tests.c:495: warning: format '%d' expects type 'int', but argum=
ent 3 has type 'long int'
> mq_perf_tests.c:498: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'long long unsigned int'
> mq_perf_tests.c:500: warning: format '%d' expects type 'int', but argum=
ent 2 has type '__time_t'
> mq_perf_tests.c:500: warning: format '%d' expects type 'int', but argum=
ent 3 has type 'long int'
> mq_perf_tests.c:503: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'long long unsigned int'
> mq_perf_tests.c: In function 'main':
> mq_perf_tests.c:651: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'rlim_t'
> mq_perf_tests.c:652: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'rlim_t'
> mq_perf_tests.c:666: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'rlim_t'
> mq_perf_tests.c:668: warning: format '%d' expects type 'int', but argum=
ent 2 has type 'rlim_t'
>=20
> I assume part of it is this:
>=20
> /usr/include/bits/resource.h:typedef __rlim64_t rlim_t;
>=20
> But I didn't look into the others.  I can do so?

I don't get any of that sort of noise, it all compiles cleanly here.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigADF70F504B2E2E6A55A0B9AB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPoEQTAAoJELgmozMOVy/daCkP/3cgq8lzjIXKrl99RS4w21hD
OfK2oU8BGIPYdwCW068BIyGH6+KGl2+GMLTdDHMujH0gYevriBrIRC5vw1+rFri0
mOg+Xoz21xI3B4XuTIhq1DOzlUDWlw1RcOyuQFFCyyqEdVOgwDjQkmcEU7fLzq48
sPb1dZUSc046cSpa1d61OSERI29sYQ+X0n4d3vSV0CZ1oOlEezBiwmoFRFVuAabt
3wwGTOY6W1DGiF9dYN85zXNG2T6yWsCO+gKzMjC/TdJXa+VXw4dOZ7ympFPBmOCI
o8nBk/Bvpfxmy2Yca0EhjWwNI9BmetM/huK+q9R/rFeBhyzJiM3GT8qQZv4wVBD7
+XZpBQpHgBxqvLvdLoIRagp24XqXyX9SCvDZXk66TyNPnvxLUpUkWsjc8V06iT6f
Px4RIj2fsC5WzS64meIU/eEp7kcIbZpPDjD+wswv+P4moq2Yz3q65u//z3tyXzlc
xxxocEs01NwLrkWRAjKZhyB1Prn7+eJ+f3PCdJAJlg4ml3iznT7KTiZuZAvyPuic
XgBdhEPKIqI8tewSLQtTMBaTPZV5NkVw5wvYM79fszSW+/fjS1LFDqGxzHnFcrnT
Glu+/UdYC8J0QSAUDtm38USY4ltM55X8GHAGDsdGPpnOpmgT5WmQH19XXtAfmyf1
LCbFRLW9E9yHGG7IUN9o
=QbZK
-----END PGP SIGNATURE-----

--------------enigADF70F504B2E2E6A55A0B9AB--
