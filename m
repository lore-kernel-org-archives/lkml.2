Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2IMMZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:25:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46910 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab2IMMZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:25:00 -0400
Date: Thu, 13 Sep 2012 22:24:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Henrik Rydberg <rydberg@bitmath.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Minchan Kim <minchan@kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Ping Cheng <pingc@wacom.com>
Subject: Re: linux-next: Tree for Sept 12 (kernel-panic after pressing any
 key at X login)
Message-Id: <20120913222442.a29eac00eb44b27dd1a86a1e@canb.auug.org.au>
In-Reply-To: <CA+icZUVH7Nm6WDau+dSgf9kQGaE5-06tPEOpukSJPc2z7gjR=A@mail.gmail.com>
References: <CA+icZUVEQNPGL7_BbLA-urgP6rFvdOh0SUtYESUv6ZJc+w78Nw@mail.gmail.com>
	<CA+icZUXqzV=YFjHT=5QxUf1_WHwS1-DhuXkhN8QAhn1t9+-PYA@mail.gmail.com>
	<20120913060412.GB5085@bbox>
	<CA+icZUUF=vTwSoNrs-+F08H7LAO0RUwztJ3M1_iyNR28TsrFMw@mail.gmail.com>
	<20120913064909.GF17105@core.coreip.homeip.net>
	<20120913070410.GA309@polaris.bitmath.org>
	<CA+icZUVH7Nm6WDau+dSgf9kQGaE5-06tPEOpukSJPc2z7gjR=A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_22_24_42_+1000_+3MJ.41Ud2SwDTD8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_22_24_42_+1000_+3MJ.41Ud2SwDTD8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Thu, 13 Sep 2012 10:18:28 +0200 Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>
> Stephen, can you apply this to today's linux-next (next-20120913), please?

Sorry, it was just a little too late.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_22_24_42_+1000_+3MJ.41Ud2SwDTD8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUdCKAAoJEECxmPOUX5FE4OoP/Rbu8F2t5O/pZoM9fBZDR1p5
KEvscXX/Q1hzzA6It8cN4/us2uQ3B5LQzg0ryHMgEwNxwz/glby9uN6/XFtTu7Xj
WcHJMqycJpKzrWg7xps2SDYIwVtUBAsUVhN90VL6F2zy0FxlB7PzcDq19hu/Avqr
nSCvEnS2anAWSrWoukE+Oi+qgmadadtPt7Z3FsiQ292sn+XHhM8/4T01zJ+5y6+V
F2W+o8de1+IWbxJXN2kt/m9kk7LHZoay9TwgCnFLXw9AVDwWWPAuqUMR6Wgq8kbB
npbrYimY3AxfP59COGoyLAsb6QoJeMC/PAaI8EFIMOpgq1cTlutg30NmA5D1cM2G
TqyJ5RA9yZGKtS+H8CVO6GhbF3SGdK8/ZuKHcZwUSBQI21VI+7LlnnWbidyQKUKv
BgvDE9Yn7d13WBn3QcVBJ5rGqdjlPj1WaRVCXRlDGyEXOwIELklqph1Jc1DZysvI
Qpd6gHjA/qfNohlajixbfc/Xe0GKoKkgQOetDoICt9Vq+Qi+KHnU5Yxb+hag3dq4
7CsLiMhZg5JSva433ulvgatYt833BP11UFt6K75jKksoWRLdvxLgu2lWgpTvzATV
O43ZQbNhWIJDIseZk5sxb6rWW5klBoUvNAG8hmRWd2sbm4nH9jFwMsPP9ZJkdLay
WTW6I4yJ9jWLHUxvctEc
=873h
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_22_24_42_+1000_+3MJ.41Ud2SwDTD8--
