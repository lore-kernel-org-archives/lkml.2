Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1HSLbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:31:40 -0400
Received: from fsing.rootsland.net ([62.141.37.30]:54054 "EHLO
	fsing.rootsland.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1HSLbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:31:39 -0400
X-DKIM: OpenDKIM Filter v2.1.3 fsing.rootsland.net 23EC712FC81E9
Date: Fri, 19 Aug 2011 13:31:32 +0200
From: Stephan Seitz <stse+lkml@fsing.rootsland.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #40282] IP forwarding regression since 3.0-rc6
Message-ID: <20110819T132841.GA.a087a.stse@fsing.rootsland.net>
Mail-Followup-To: Stephan Seitz <stse+lkml@fsing.rootsland.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
 <bkwpSnItbJM.A.r-H.mMCSOB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <bkwpSnItbJM.A.r-H.mMCSOB@chimera>
Organization: Minas Tirith, Gondor
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 14, 2011 at 09:07:36PM +0200, Rafael J. Wysocki wrote:
>This message has been generated automatically as a part of a report
>of regressions introduced between 2.6.39 and 3.0.
>
>The following bug entry is on the current list of known regressions
>introduced between 2.6.39 and 3.0.  Please verify if it still should
>be listed and let the tracking team know (either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D40282
>Subject		: IP forwarding regression since 3.0-rc6
>Submitter	: Stephan Seitz <stse+lkml@fsing.rootsland.net>
>Date		: 2011-07-25 12:51 (21 days old)
>Message-ID	: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
>References	: http://marc.info/?l=3Dlinux-kernel&m=3D131159880004908&w=3D2

It seems the bug has been completely fixed in kernel 3.0.3. At least=20
I don=E2=80=99t have any problems anymore. So I think the bug can be closed.

Thank you all for helping and fixing the bug.

Shade and sweet water!

	Stephan

--=20
| Stephan Seitz             E-Mail: stse@fsing.rootsland.net |
| PGP Public Keys: http://fsing.rootsland.net/~stse/pgp.html |

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5OSZQACgkQXse+NwPOAZ6WZwCffX0wR5LRvAKrrOpQjriR8dXC
r3AAn3a+JTlcl/ejh8YxdPHUc9F5uW1P
=I7Ae
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
