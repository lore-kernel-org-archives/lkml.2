Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1JLN0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:26:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1JLN0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:26:20 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=NFX316_vVeIA:10 a=5SG0PmZfjMsA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=NEAV23lmAAAA:8 a=iVtBtYpV1l-ycE1rTQMA:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=Xjh8pU3JKGIVh3W9GzMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318425974.13262.26.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2 v2] [GIT PULL][v3.2] tracing: queued updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 12 Oct 2011 09:26:14 -0400
In-Reply-To: <1318418515.13262.21.camel@gandalf.stny.rr.com>
References: <20111011152026.701326733@goodmis.org>
	 <20111012081629.GA25086@elte.hu>
	 <1318418515.13262.21.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6E9WKjx8Yh4L8ar+LFzT"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6E9WKjx8Yh4L8ar+LFzT
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-10-12 at 07:21 -0400, Steven Rostedt wrote:
> [ Added hpa ]
>=20
> On Wed, 2011-10-12 at 10:16 +0200, Ingo Molnar wrote:
> > =20
> > > Please pull the latest tip/perf/core tree, which can be found at:
> > >=20
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.g=
it
> > > tip/perf/core
> > >=20
> > > Head SHA1: d696b58ca2c3ca76e784ef89a7e0453d9b7ab187
> >=20
> > Hm, even after 12+ hours of wait i can only pull 177e216 from your=20
> > tip/perf/core. Is this a korg delay, or did you forget to push? The=20
> > perf/urgent branch was there, so i don't think it's korg delay.
>=20
> I just tried again, and got:
>=20
> $ git push push trace/tip/perf/core:tip/perf/core
> Enter passphrase for key '/home/rostedt/.ssh/id_rsa_korg':=20
> Everything up-to-date

> It seems that gitolite isn't refreshing rebases?


There seems to be issues with kernel.org refreshing. You can get the
same branch at my github repo:

  git://github.com/rostedt/linux.git
tip/perf/core


It has the same SHA1: d696b58ca2c3ca76e784ef89a7e0453d9b7ab187

-- Steve


--=-6E9WKjx8Yh4L8ar+LFzT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOlZV2AAoJEIy3vGnGbaoAQlcP/RjQ5ENpIc68In9QYgKbzE/9
vJepmwHWYunj84VB6pI6A2ZzVezOEH3SLb1ilH9tPr1BeSXJBU2ekoKMu/b064+i
+gHwox2aQGVqETzCuf3ovOKnv4ImhcBwSYsamGmwTieKJDmOIy816uX7kF8MKgDS
leyHTeE1+N+ISiXhXXfxVww9MAX5KCMsQ4mp0H5eddWPqZr10YvccbcyqkdE1afW
V4ajC0Ml72mRFC5QjhO1iXhHVhsg8gyMpeq3hmaMf1K4K/IJn3pM2hoIARaR3Jvh
yUgIKDyyd9lpfnHOBu6lOvM44hlJ2LOAmIKcjpyHxDzqA8aZUE4MOcmojkuOvlHV
cat/tOPTZL8DQolJUCqWdbhi5FzilA7RhCBf+ijjg8R3VcKi2LwZuB4wwr6h0TiA
K18y2uEdOlE2djRLnJa7b+EbR6d08zWXz9+W15cRx/lzkJKl9keYbu4BuDOn6YSp
L7Wl6jnOctjz8T7U7OyAfI7lbC7AlkDpfL5xEESIRYJvzSNRSzBnDh66nMLtNADJ
dCtqgv1HR04Q7JAI26ELbQxb8Yi6phzPJYku/yo/yXNs92YBYbFPyY6RyCbi8s27
k3pgYfSsfw1v85El7TqDsfFeFvV78M/VBki7QYF3PLKpGmByTCvTjqNcG+3pFTsq
D+9NoDIYRhPRYcaIID8s
=ylfj
-----END PGP SIGNATURE-----

--=-6E9WKjx8Yh4L8ar+LFzT--

