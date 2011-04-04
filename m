Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1DDWDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:03:20 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37257 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1DDWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:03:19 -0400
Date: Mon, 4 Apr 2011 17:03:09 -0500
From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110404220309.GA10229@peq.hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com>
 <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
 <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>
 <4D9A00B1.2080002@cs.columbia.edu>
 <1301953409.31531.130.camel@tp-t61>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <1301953409.31531.130.camel@tp-t61>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Quoting Nathan Lynch (ntl@pobox.com):
> On Mon, 2011-04-04 at 13:32 -0400, Oren Laadan wrote:
> > From the technical point of view it *is* a big problem:  there are
> > very good reasons why we chose a certain design.=20
> >=20
> > If Natahan is suggesting in-kernel tree creation as a temporary thing
> > to simplify the code for review - then, given that this patch handles
> > a single process, doing so add lots of unnecessary code, all of which
> > in the kernel.
> >=20
> > If this is the beginning of a permanent approach, then it is totally
> > incompatible with what we have done so far, and severely restricts=20
> > the kind of use--cases of the project, potentially making it too
> > unattractive for many natural adaptors, like HPC users. Sorry, nack.
>=20
> It's not a stopgap measure to "ease review" or whatever; recreating the
> task tree in-kernel is a fundamental - and simplifying - part of the

I hadn't gotten to that part yet, so I'm on the fence.

The API for starting a checkpoint, that I'm not on the fence on.

-serge

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNmkAdAAoJEHmllQITXQdFgPgH/0Z7FN38XsLCtBToSwRdoSLf
F6XIBNg26GXZRv45OCAZTMkcM53FqdJboK9fDGKZNAWH40i+koGJ9xOj/Q5GQG+f
wmg32DQw6+GuvInAnOgxQrpne7AA1vJyHcDvZvKWzQqL7Dtok7amJGqBvnXMRd3l
z78LvbNU++4F7dP4Uq0crC4yneztHwQ6S8/VaQGD9AReTMFTt4a289gFSjHLUHvg
95tDzNe/U5KP7pui9Qk9J0TVH3Udptp/JcSzncOkzlhNu53FZYus3dZ3eOgB04cl
IrzNMeA/KfTFipMON6smWPQePIaL0x4vz7eRMASCvKFadOsVaCPg37IBVeiN25k=
=ldML
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
