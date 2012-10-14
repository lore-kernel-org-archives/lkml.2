Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2JNJOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 05:14:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43806 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab2JNJO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 05:14:29 -0400
Message-ID: <1350206037.4832.70.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 0/5] Memory policy corruption fixes -stable
From: Ben Hutchings <ben@decadent.org.uk>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Date: Sun, 14 Oct 2012 10:13:57 +0100
In-Reply-To: <1349801921-16598-1-git-send-email-mgorman@suse.de>
References: <1349801921-16598-1-git-send-email-mgorman@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-61g0PzXVN+TYbu3M3vlZ"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-61g0PzXVN+TYbu3M3vlZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-09 at 17:58 +0100, Mel Gorman wrote:
> This is a backport of the series "Memory policy corruption fixes V2". Thi=
s
> should apply to 3.6-stable, 3.5-stable, 3.4-stable and 3.0-stable without
> any difficulty.  It will not apply cleanly to 3.2 but just drop the "reve=
rt"
> patch and the rest of the series should apply.
>=20
> I tested 3.6-stable and 3.0-stable with just the revert and trinity break=
s
> as expected for the mempolicy tests. Applying the full series in both cas=
e
> allowed trinity to complete successfully. Andi Kleen reported previously
> that the series fixed a database performance regression[1].
>=20
> [1] https://lkml.org/lkml/2012/8/22/585
>=20
>  include/linux/mempolicy.h |    2 +-
>  mm/mempolicy.c            |  137 +++++++++++++++++++++++++++++----------=
------
>  2 files changed, 89 insertions(+), 50 deletions(-)

I've queued up patches 2-5 for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-61g0PzXVN+TYbu3M3vlZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHqCVee/yOyVhhEJAQpZXhAAj/pB8wli2Twm9uuaomY8RMcxOUCbemEo
7ef6AKi5A2OC1q1TAhg4mJVSoFd8U1ZhQp56v/lteh6JXUNjnjthwclmvdSPNBFE
A1MU5kXjqw00AlVOOMIaiB/yAGsdcpjzOCIfBXJ0x9z2cZHZC7+kZ0LLp+Smp269
Kl/sKDvqW4hKqhNVL1xjKFeR4kBU3KxqqAA/ETm/N4FXiuUtl+LnqcRkCDkKCEVY
FCgMDBmc/2N0kvCsGMqH7xfgNnJgNABfGIWUKrxue3Eu29Fm1ORU4CDaNjEorvcX
HV1Sn0p6pFUrPyau4fu5Jd5gi4aHQ7E6F1V+j7/6ITIDtTaVCsTLsn3T3j2s+5At
6uR678WKDeGySnZ1LQn59doPvhAakRZkZ3EM8gH2qZM0V6rtNCJXxxqlry+6tbcO
bcWx9Zwe1g9feqtR/xYMPPMtZKreU7SOfmOsI2eEdPRE4QHUVDggHT6NGliGNSyU
N8zjThiAnR5Tj1UAt8YVCAD8SFVHMbptEEMjnfMtUvIepViOvw0onBsUq9Y53Viu
4Gjt4GSiRE5bZDJy32Z4eL15XvnND5S11cnNRdP8B8f3hZfqeXps94w+Y1MWYsnE
AlE22VBbxD/lvOLDn1b+cW92Xvn/SVtWYW1bHpNgg0k9XrDR8YWBlQRfpgpf1Tyi
jTfSOwiTakg=
=qYk6
-----END PGP SIGNATURE-----

--=-61g0PzXVN+TYbu3M3vlZ--
