Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2IVJOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 05:14:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33030 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2IVJOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 05:14:33 -0400
Message-ID: <505D816B.4080902@gmail.com>
Date: Sat, 22 Sep 2012 11:14:19 +0200
From: Andrzej Giniewicz <gginiu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Sound got mute in kernel 3.5.4 (Fast Track Pro USB Sound Card),
 found commit that causes it - how to proceed?
References: <505B455D.2040603@gmail.com>
In-Reply-To: <505B455D.2040603@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8ED0781EED134049A4CE0195"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8ED0781EED134049A4CE0195
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 20.09.2012 18:33, Andrzej Giniewicz wrote:
> today I updated kernel to 3.5.4 and noticed, that all my sound from Fas=
t
> Track Pro USB Sound Card got mute. I haven't noticed any error reports
> or messages, all seems to work, the card is just silent. I downgraded t=
o
> 3.5.3 and applied patched from usb sound module one by one and found
> out, that 3.5.4 minus " ALSA: snd-usb: fix calls to next_packet_size "
> works fine:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
commitdiff;h=3Dca150f7ade5973c3bce19261bca6174d5c3cc342

On Arch Linux forums we got another report, that USB Sound Card got
mute, and works again after removing that change, so there are least two
affected devices now:

ID 04d2:5051 Altec Lansing Technologies
ID 0763:2012 Midiman M-Audio Fast Track Pro


--------------enig8ED0781EED134049A4CE0195
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQXYF0AAoJEED1V7cxSWEGemgIAM/sCYdzUnj50DElcL7eDHwk
1bxNfCh5l7CLEuQvIt5sQTVp6kFxQCFq4C9gSGvVG7haGXQU+yYg/YXOuRs/pkC2
Y14Plwr0WplXlKw20ie0W6n/454RP6i5a5iu6vLhvEsfkejLvo4fHWv/pelyuCEa
3JOZGURhlEw+5al6kGT+RqPqZv7teOTJsZ15iPU90r5biKI6pCV6uiy8Vu6oCEk4
5w64yeN/slqB2RpC4cTZi257mjRhjDIugSWwu59u0L0y5W/pQ85as1jyO/0yA7iz
vThPyAvv2/kpIl02miQlKUPZfptdDIsM60XfRCS7KUxdZDHMofeUUWE0xHiSRLM=
=6zw7
-----END PGP SIGNATURE-----

--------------enig8ED0781EED134049A4CE0195--
