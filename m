Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2JCOue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:50:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46849 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352Ab2JCOuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:50:32 -0400
Message-ID: <1349275814.16173.13.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 008/180] 2.6.32.x: ntp: Fix leap-second hrtimer livelock
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Date: Wed, 03 Oct 2012 15:50:14 +0100
In-Reply-To: <20121001225157.951753597@1wt.eu>
References: <20121001225157.951753597@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-tvjBlYCSroZxjLmd/Goq"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tvjBlYCSroZxjLmd/Goq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-02 at 00:52 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
[...]

No objection, but please remove the '2.6.32.x: ' prefix from the subject
before committing this and the other ntp/timekeeping/hrtimer fixes.

Ben.

--=20
Ben Hutchings
For every complex problem
there is a solution that is simple, neat, and wrong.

--=-tvjBlYCSroZxjLmd/Goq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGxQpue/yOyVhhEJAQqzxRAA1a7oumhhBONtZpba41x9xAQdpMFTaU1N
feqP2JpUbqd4cp7H5F7iwA4YqJwD7FT2C5+4+WyOMwqBgpRu7OX9XPpeIxVoA2ki
sqfST9P+jYGGtpeAS2DIwrS1l7bnWUpSdejl99/NtRzSL64Krk23hQCJSq5ONM0o
ZvDYIblqjI7V1LfFMARH5iW2oAH6VDTNZ1PpBe0lh3zL+O8K0tcZpzKFxY70iXMl
D7ZzUmDTINUCJus/kOmiLbMngw6UwWZxOST9wbrlAAuozOhNVoXmC2NJEEuPZh3V
omgztwcoN1GAgKBwSXkNqdh7GaB00qaT/qNm0ImYfyWG7ruP+xjhLAPM9OiwHqYV
uUWcQyOQbkM1v+kEnoSuGb9R0BiI6yed9jD4BH56eXj/jqbE0hfbx/TrSPu6eGyC
brgrShtucaP46SuqMpKJZrDgp8YRW/CQ2r2VzpPWlC3gktmdOCyIZpchqBOKZTZm
Wr9vAD45wcDFgSYIB9A5ZfY3TNiutoReErAlYwh2w5k7kpgiQWZQx8HSMaTLS4qA
nnaMfWXXaBxaSBs5+WcV+b89FUXjjWnwB4BJAd0BGXXRIhRoiXzjYHnH2UnYPL3C
qVlzQGGdQ2vhufeggEBmCzCFmK+q52yLru9FKYDWGeL5WFz3vf2V04gv/mZ5PJoj
XnVV2zyD6nk=
=5UTE
-----END PGP SIGNATURE-----

--=-tvjBlYCSroZxjLmd/Goq--
