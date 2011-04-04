Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1DDSvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:51:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35353 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab1DDSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:51:31 -0400
Date: Mon, 4 Apr 2011 13:51:20 -0500
From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        containers@lists.linux-foundation.org, Nathan Lynch <ntl@pobox.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110404185119.GB4782@peq.hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com>
 <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
 <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>
 <20110404104119.78189678.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20110404104119.78189678.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Mon, 4 Apr 2011 11:27:53 -0500 "Serge E. Hallyn" <serge@hallyn.com> wr=
ote:
>=20
> > Andrew (Cc:d), did you see this thread go by, and it did it look
> > in any way more palatable to you?  Have you had any thoughts on
> > checkpoint/restart in the last few months?  Or did that horse quietly
> > die over winter?
>=20
> argh, it was the victim of LIFO.
>=20
> All I can say at this stage is that I'll be interested next time it
> comes past, sorry.

Thanks, that's good to know.

As you know, we started with a minimal patchset, then grew it over time
to answer the "but how will you (xyz) without uglifying the kernel".
Would you recommend we go back to keeping a separate minimal patchset,
or that we develop on the current, pretty feature-full version?  I'm not
convinced believe there will be bandwidth to keep two trees and do both
justice.

thanks,
-serge

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNmhMnAAoJEHmllQITXQdFz4kIAJnRFp4UJ/LE2ycg/vzD+HW8
pCygLgGOayTmoZqyms5T51P3ObbRYY98L3pUMMExc9/kQ8bdeWnH5s7D93QzTHYP
7+PxCW/c3jA8Nc9BOnIImMelUhFCcjyp0YyAHbMQN8Ej5DuAJOrgjwpyAeQRbhUR
rR74y8rlOFB+4FEDOpLwnM0xawfTPyW4VB6Vk5/8VjkEaDvcWB+/cuBboMuA8uYO
gqH7v1EyJxaeuJ0nAjrnvgDXyCfpWJNmiVVlS/B+x8w+CGRxcd8WBsZ/UU7bAGen
NCw17QyVsaAn6KwBU8YZeKZLto39kINHwFyDTjcm6N0EuCQ1JTiRvOiXUO9phRE=
=VIBb
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
