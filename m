Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2DZGCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:02:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2DZGCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:02:35 -0400
Date: Thu, 26 Apr 2012 16:02:27 +1000
From: NeilBrown <neilb@suse.de>
To: shuahkhan@gmail.com
Cc: akpm@linux-foundation.org, Jonas Bonn <jonas@southpole.se>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH  v2] leds: add new transient trigger for one shot timer
 activation
Message-ID: <20120426160227.214fcb17@notabene.brown>
In-Reply-To: <1335375758.5313.22.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2>
	<1334064283.10826.6.camel@ted>
	<1334507752.2723.3.camel@lorien2>
	<1334894674.3051.18.camel@lorien2>
	<1334983269.2435.90.camel@jerome.southpole.se>
	<1335138687.2882.20.camel@lorien2>
	<20120423115610.2da4d4d7@notabene.brown>
	<1335158999.5139.47.camel@jerome.southpole.se>
	<20120423154546.415bd6c0@notabene.brown>
	<1335219745.2850.7.camel@lorien2>
	<1335375758.5313.22.camel@lorien2>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r3NBwOYtFcAXHb6iQm/ZXW5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/r3NBwOYtFcAXHb6iQm/ZXW5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 11:42:38 -0600 Shuah Khan <shuahkhan@gmail.com> wrote:

> There was a suggestion to change units to seconds similar to "safe_delay_=
show"=20
> and "safe_delay_store" in drivers/md/md.c. safe_delay_show shows time in
> seconds, however safe_delay_store still takes the value in msecs. This
> sounded like an asymmetric interface.

I don't think you read the code properly.  "strict_strtoul_scaled" takes
a number like "0.20" and scales it to an integer...
(though your decision not to take that approach may still be justified).

NeilBrown

--Sig_/r3NBwOYtFcAXHb6iQm/ZXW5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5jk8znsnt1WYoG5AQJTVRAAvQqYDDicnm+9VfOs90Rlr/fHnSIw+2hi
4kjspKilDI++JFnFmGQkko66Uc5MUxzO/SxkQA/snKKLsUZrh53bNa+oYabbcAhy
H8DgLHfjImKRl6d6zp3zY/ES+bhRdfx9N5GkBiL3xBqtIWVJTLGswIq/970sWp4R
aFnAuPNc2slejfE/Znmq+TQd1V2EYEE1p6mlUtmg+2hUVJptl+gCY6FxXryhd4hY
Z4ocA2TKp4kpxjfJti38DajItZClKRmtpHcLptHU+hKPx8K2Lxl9jZP/d7yWzgOk
9llvgK5U0Ae6tHquG1v1Sx/LXyuKlduTyHiYXJ9p/QRXBQpEZBvLB7Jbkz7N/A97
kMMotTiB+hys+x6FC0qWbysyUajS1Pt3RpkqrRJmWm+UUq/r3dvp2I5DgR2RQ724
bJtBYZqux4420a3amEo6BZT/MdLI51EaAUibcRrka+bKo/Vx3bxbxouXMG34Cna7
BUn+xdlmC9HyjtNOzGdNdBHQ0jsVbMCI+LOE2hm++dkxUO79t6/IxFbJOr9n3Who
du1ejDfb5P3TZmA4Fy0xMoCC7kEgyNuPmKsgKo+8udYcwaRHUjTKPtA4ip7zvVmM
rFSDax0HJYCMwqOGEG0AFnYl7IRQa6qqGFl80UA1OjgZx6iIb41R1H/OXpoxyeCl
+SCWnN/OKSU=
=og4k
-----END PGP SIGNATURE-----

--Sig_/r3NBwOYtFcAXHb6iQm/ZXW5--
