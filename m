Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1JSLEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 07:04:32 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:38868 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1JSLEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 07:04:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9EAEB7.6080601@cam.ac.uk>
Date: Wed, 19 Oct 2011 12:04:23 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
References: <4E9D9558.7040705@cam.ac.uk> <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com> <1318982469.7569.1.camel@Joe-Laptop> <alpine.DEB.2.00.1110181819110.12850@chino.kir.corp.google.com> <4E9E89F2.2060103@cam.ac.uk> <20111019102630.GE3217@pengutronix.de>
In-Reply-To: <20111019102630.GE3217@pengutronix.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDD500435FB3D15A674F4ED0A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDD500435FB3D15A674F4ED0A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/19/11 11:26, Wolfram Sang wrote:
>=20
>> Sorry, I missed one detail. This warning is firing on every patch incl=
uding
>> any I pull off mailing lists or produce with git format-patch
>=20
> So, I assume you have a directory named 'b' in the kernel-root-dir?
File, but good call.  Thanks.  All back to normal now.
I'll have to be more creative with naming my random temporary diff files =
;)
(or remember to delete them afterwards).
>=20
> The p1-detection is heuristic and can always be fooled, so I don't thin=
k
> extending the logic will help. If too many users think it is annoying,
> it may be better to remove it. I do think, however, that it might help
> users sending in their first patches, so I'd prefer to keep it.
> Experienced users have the option to use something like "--ignore
> PATCH_PREFIX" in their .checkpatch.conf. I vote for improving the error=

> message but won't oppose a removal if that is what is wanted.

Maybe something as simple as a comment in the checkpatch source
to say that such a file / directory can cause false positives?

Thanks again

Jonathan



--------------enigDD500435FB3D15A674F4ED0A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIbBAEBAgAGBQJOnq7BAAoJEFSFNJnE9BaIySkP+N02dO74GgPl+MR9R6lIJGbN
s0wYlEYHP4o06QGn7sqBhXBkzyYEBiwFBj5zlPaPohUwpopqN7LBwJk6SpcNnLTR
nbuYthptGTxxaInvNXth34Jh1BQt3EUdpRiqVgfQgf8/tWa10CN0fS0Z3mS10wxy
XGTRCFcG6NHdPQ+pSn3bujwP+uhaaTfTvg8msjIBhlTBQ5K92mjGJFyYMdUzJq/A
NrYcv6hz4siysNS9ozeK+vfJx6OlRPsGJrBPYa1kKXZaRSZqg3c3HJJwn9lO1t4n
dn8hAaxEJ9H+FX6bq614kD076wV3WvAnJLKA2XI+ySQp2HWzNZLHld2rEPHfCMKc
+1bBstFejHGOAoFN0Mh9MRBKSd8h3tdp2/5G3ek5i9C4MV07oNHlxn4EKyZIueyr
I9Llia4zCmFJvH2MRJpTzdT8AN2w4azHf84nlHvLdo1qXkGGFW97etYlk/WZFkJu
Q03Yzlzw7/3gIwoO+FOPUTHu0aWa572FAhCziikP9XI4fdSTLkHdkt/CrqdwEQfF
Y2zNvpVm0ukCJBGjvyLnHzNY7lY6kTsccg1bOQSZ7hHyhIteWEl06PDgXdiw0oOf
GbQaBtmxkEH/aTsRmubWLu5gUGoIBcQw1KGpt0/uvFbSSatKjZpC3Nt2biODjxAX
RCWvmwbrxR7536CHry4=
=HnjG
-----END PGP SIGNATURE-----

--------------enigDD500435FB3D15A674F4ED0A--
