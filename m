Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2IBUqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:46:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2IBUq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:46:29 -0400
Date: Sun, 2 Sep 2012 22:46:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH 2/3] MIPS: JZ4740: Export timer API
Message-ID: <20120902204624.GC21635@avionic-0098.mockup.avionic-design.de>
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
 <1346579550-5990-3-git-send-email-thierry.reding@avionic-design.de>
 <50437117.8000700@metafoo.de>
 <20120902202124.GA21635@avionic-0098.mockup.avionic-design.de>
 <5043C139.2010700@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <5043C139.2010700@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:57/T1gPWzzr1/CoW8o5/G+57k2wz3faaVfTNA3CP/FC
 Pkdaq2pTSXRlkfO45pgrXaIQ6wK+5SXN7EeForI0NpDZY4l2d6
 jvDtyVB7ISc2lllOg/iQLrCSgbscfJvCR5CA1+rACjs9I/IVhY
 GRCZr8OsxcvMDj8J2sEvKQ77C6PgWvIAv7f1C8pdQ+gTgzwoDK
 x/l8YMYrMWaxX2X2A0SMzEis0iVahyitWVyLAP7ycJwps8c6Zq
 VFY+SZDsnlzQ3CHp+BCxACXtpI+fo84rwNYhuPjLwW/C4HNOof
 I47KFBLmjP/ChscQ4r1TYVBd5V9Kz1lCxVw5kQavTo2zRAsz1C
 GzwfSylEMfK71PX1RD82psyIp1dceRMn+TxDjfXFr3JhPPVU6u
 F6AnENONWxXJIgBDlbnSzNziioJLQQ/95gPX7VRNAeQDmAgj/T
 ry4Vc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 02, 2012 at 10:27:37PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2012 10:21 PM, Thierry Reding wrote:
> > On Sun, Sep 02, 2012 at 04:45:43PM +0200, Lars-Peter Clausen wrote:
> >> On 09/02/2012 11:52 AM, Thierry Reding wrote:
> >>> This is a prerequisite for allowing the PWM driver to be converted to
> >>> the PWM framework.
> >>>
> >>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> >>
> >> I'd prefer to keep the timer functions inline, some of them are called=
 quite
> >> often in the system clock code.
> >=20
> > I've opted for this variant because it better hides the register values.
> > If the functions are inlined it also means the complete register
> > definitions need to go into timer.h. If you don't think that's an issue,
> > I can update the patch accordingly.
> >=20
>=20
> It's not pretty, but it should be ok. Having a single global function for=
 each
> and every register access is kind of ugly too.

Okay, I'll update the patch accordingly. I probably won't get around to
it until later this week because I won't have access to a computer for a
few days but I'll be back at work on September 10 and should be able to
send the next version of this series out then.

Thierry

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQQ8WgAAoJEN0jrNd/PrOhm+EP/0Adl62IwELOR83e+uqIEADM
+aLp3NHggdPe77rf/Tjn6zooAS7aPFnsqpave99BP8f5SzzbPI3i5GQRUVwA6TdP
n+ivzgX5R8ml/5XqYtvX3y086c+1/1axvnj6D6FqJ/v/SN10I9GioiPMFtYwcK/S
RfMvnlltpfcmO/ysvbXODnmlWEHb6oOUnzfVfQpd6SvCGQbJTeVMCZuNw5hMHKbs
gg5SC/tDmsfrIqj7xuoXj9n9Ct+MH64hv8V5rDOmPqXM3RYG4XWX1d0nIYP1RCIi
pijBA3q7jTlOrV7pHV+F0os15U/AagXlFZIRJAbcCuiNgIMd4FKqgM3AwHV+bhgT
JzmTaEyS5F34keMbY/4qnn5B/cFRhHDURg5z9Yo7mDnkYjWbOifj15cgjYZHZEZe
YAqhmhLm71IQRmrqTc81QZpigwttlHzG46DsJoUyvuxabMIHRZKMo2vlTydbbp5r
bpqu3xF8jJkauORIKXNvKaeX9zfpFKOy4QRnCYSpFczMjNeYc+E9iPNBVuNHCYy5
L68uIK88nzFikNRoEStJdHUKsu9W9H9QDBPrnzIMbgqOJp1ab/i8QW59sRm4dPf+
jSXpiV/3JJX9JBGiCKq8lOxZzm+Xlg7QZbfooCvmzxyQWrrD8kl79sqtTNaYxTn9
uyrYOCe0nDpcxMOunq0F
=TXny
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
