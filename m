Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2B0GTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:19:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60958 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2B0GTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:19:39 -0500
Date: Mon, 27 Feb 2012 17:19:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120227171929.d3bb057460c0e4fcd7d8d7ff@canb.auug.org.au>
In-Reply-To: <4F4B1C31.7070808@zytor.com>
References: <20120227165356.6119ac92eabd7052fc56c741@canb.auug.org.au>
	<4F4B1C31.7070808@zytor.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_17_19_29_+1100_A6Y04Sdc2UVJA6IP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_17_19_29_+1100_A6Y04Sdc2UVJA6IP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Sun, 26 Feb 2012 22:01:21 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> It should be "common" (otherwise there would need to be an x32 variant
> which would point to the compat version of the call, but in this case
> even the i386 entry point goes straight to sys_kcmp.)

Thanks, I will fix up the merge resolution tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_Feb_2012_17_19_29_+1100_A6Y04Sdc2UVJA6IP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSyBxAAoJEECxmPOUX5FEApQQAIiqB/1f7J0pjwk8BZWJf+wt
F1gExUAJgHDD+oH4mk3dPR0Bqg04fLqfFdA1qcKhjSa4z1sBL+cHCd+ySZOPEV+z
um5U8Sr6o5TAV91sms6w0Sm/sOGg+4F9DmN0dnlL7zj1WHOYA0mu4ufwv9DxmYR0
E+1LDJslkG+ktYZ/eqC1cm8NbrC35ijnEZXgIcL1gT2DwAnnUVCip+9DXbqzAtfp
aCPHNtR3JWvePzsCj4ckCzPb7UhMZaQbptoW8aRXN2nbHpPATF4ItT5fXLcOnrlh
JpPgrnsx4reg82KVSCvRJdMq/ruZX1gpRd5lTWP3kRGx486sDaSfrJUbsS4tMtsa
xolFCHYcV5XvVQPss/GiifM714V/yqIzOpi95rOmkTHOCQEOchW8N4UA0fZcrNwJ
xOQAn7cdyQeyNMDiwHO+UOl/ofxvyLdDWd/Lcp4eDzq6IlNEQTEOn8P14fA6lWH3
z2j+Xxh7rLYB85i5tv9TSI7jWzitkVUedtgt1Xc0NmBtNcbvG+OEl/p2PUVKl8Lu
HETz+AqvBPP+cOgF3bbdfpo8Z7VlZa2ngsCMs5TR8Yg92u3eZz4Hebx99tCgb5bl
tnbIdJIB9p0C3knisB7P0UEPwNRCnm9YspYNt9euTFfahLB4v0a2detbJS2KteGx
gFk9lk7pjTTz7jkzEfao
=OBmD
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_17_19_29_+1100_A6Y04Sdc2UVJA6IP--
