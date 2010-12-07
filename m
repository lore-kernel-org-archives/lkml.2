Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0LGB4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:56:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58489 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0LGB4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:56:36 -0500
Date: Tue, 7 Dec 2010 12:56:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-Id: <20101207125626.1be6cf17.sfr@canb.auug.org.au>
In-Reply-To: <20101129135045.15aec5ed.sfr@canb.auug.org.au>
References: <20101129135045.15aec5ed.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Dec_2010_12_56_26_+1100_NGyhjl5x3tsHIkyF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Dec_2010_12_56_26_+1100_NGyhjl5x3tsHIkyF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Nov 2010 13:50:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>=20
> arch/sparc/kernel/perf_event.c:1326: error: 'init_hw_perf_event' undeclar=
ed here (not in a function)
>=20
> Caused by commit 004417a6d468e24399e383645c068b498eed84ad ("perf, arch:
> Cleanup perf-pmu init vs lockup-detector").
>=20
> I reverted that commit for today.

I am still reverting that commit.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Dec_2010_12_56_26_+1100_NGyhjl5x3tsHIkyF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/ZRKAAoJEDMEi1NhKgbsEYkH/R0Ws9CZ9eGz3Xvrd/xGyKmJ
14fp4+Xr7CGP/8MOcpHycQrhEFmT04Kbp9RuAfN/XIYNvtWdDqkRxEjIjgrSPtjZ
WcyoLuBybuZ6tP23SLZBVsqpQG01wQPs023VrVtiRdDoMGULuj4HunfaTbN/pL9O
RJ1nmfuBnNGweYIRGRpR5mir0exsyhvfx/5dWqa/vA132vEXMkZnWEQyTN9ktm6w
pzQyRKZ+e7l+Hr7DwyHNIi7/ryWIH5fRzZ8kbw9+7ql5Mf+WvcltZnRTMyCmsbnr
S6Ee/caQNxeasgTk2dSxqGEOaRMGFO1mPWdogi938/k704bYAwspn4JYgMx2E2k=
=V1tx
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Dec_2010_12_56_26_+1100_NGyhjl5x3tsHIkyF--
