Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab1DHVH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:07:26 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:39138 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab1DHVHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:07:25 -0400
Message-ID: <4D9F790B.2000300@web.de>
Date: Fri, 08 Apr 2011 23:07:23 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: Re: trace-cmd errors on kvm events
References: <4D9F59AC.6080707@gmail.com>
In-Reply-To: <4D9F59AC.6080707@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF78440E34454374ABDF90092"
X-Provags-ID: V01U2FsdGVkX19l2Ia5cHSBeT3+lJnAg/V2KvcPwXKta9gwOmP2
	l7quZIxgw+UK7ZFoFrM1FZVWGzfhLW0DsOH2AcV57qHdDIUsmp
	VBUAON+I0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF78440E34454374ABDF90092
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-04-08 20:53, David Ahern wrote:
> 2.6.38.2 kernel with trace-cmd git pulled this morning:
>=20
> trace-cmd record -e kvm
>=20
> trace-cmd report 2>&1 | less
>=20
> trace-cmd: No such file or directory

Does this error come from trace-cmd failing to find its kvm plugin?
Check what strace -e open says.

Jan


--------------enigF78440E34454374ABDF90092
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk2feQsACgkQitSsb3rl5xTqxgCeJGIgeFeWrIxeBbownYf0f+uV
/BYAoOBTqE8phfy3zR2blxIca/fA7Kk0
=RU/J
-----END PGP SIGNATURE-----

--------------enigF78440E34454374ABDF90092--
