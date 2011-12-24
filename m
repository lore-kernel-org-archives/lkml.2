Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1LXQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 11:16:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab1LXQQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 11:16:57 -0500
Date: Sat, 24 Dec 2011 10:16:26 -0600
From: Clark Williams <williams@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Karsten Wiese <fzuuzf@googlemail.com>,
        Georgiewskiy Yuriy <bottleman@icf.org.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
Message-ID: <20111224101626.5c7bffc4@redhat.com>
In-Reply-To: <1324736024.8892.3.camel@acer.local.home>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.02.1112221759480.6601@icf.org.ru>
	<1324565048.5916.139.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.02.1112221926460.15997@icf.org.ru>
	<1324571011.5916.141.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.02.1112222031390.22183@icf.org.ru>
	<CAM=nh0S1zNoR7WHgQDQ2rspc3qGcKxF8nQ-VyLPhcCCGV+5gEA@mail.gmail.com>
	<1324736024.8892.3.camel@acer.local.home>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nXS=6mbc.arRN9acP87oukE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nXS=6mbc.arRN9acP87oukE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Dec 2011 09:13:42 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 2011-12-24 at 01:02 +0100, Karsten Wiese wrote:
> > Hi Steven,
> > below trace shows regularly here:
> >=20
>=20
> Thanks for the report. I'll look at it when I'm back at work on Jan 3rd.
>=20
> -- Steve
>=20
>=20

Steve, I've seen this particular problem on 3.2 as well. I don't have a
backtrace right now but I'll snag one the next time it happens.

Clark

--Sig_/nXS=6mbc.arRN9acP87oukE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk71+uQACgkQHyuj/+TTEp0NDgCgqxoTQ95g046kOTccCpsvnBsJ
AOgAn3Y1G+Jp36qMxkX1sn9oSb7SyrnO
=hNHr
-----END PGP SIGNATURE-----

--Sig_/nXS=6mbc.arRN9acP87oukE--
