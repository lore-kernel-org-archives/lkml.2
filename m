Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1D0BKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:10:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab1D0BKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:10:30 -0400
Date: Wed, 27 Apr 2011 11:10:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the cpufreq tree
Message-Id: <20110427111024.eb26b6f5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Apr_2011_11_10_24_+1000_CaGiVFLmEu3.v/WU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Apr_2011_11_10_24_+1000_CaGiVFLmEu3.v/WU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the cpufreq tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/cpufreq/Kconfig:67:warning: choice value used outside its choice gr=
oup
drivers/cpufreq/Kconfig:75:warning: choice value used outside its choice gr=
oup
drivers/cpufreq/Kconfig:84:warning: choice value used outside its choice gr=
oup
drivers/cpufreq/Kconfig:93:warning: choice value used outside its choice gr=
oup
drivers/cpufreq/Kconfig:105:warning: choice value used outside its choice g=
roup

I am not sure what has caused this.  The only change in the cpufreq tree
to that file is commit e002ba3328a2 ("[CPUFREQ] Move x86 cpufreq drivers
to drivers/cpufreq/") which rearranged a few things but nothing obvious.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Apr_2011_11_10_24_+1000_CaGiVFLmEu3.v/WU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNt20AAAoJEDMEi1NhKgbsGu8H/0rt25gPZLCsfDywEBsjDFmV
vH4aV/GxyGrQHrZ7w54DArLqZ7K021q8yrQAq/GPYX9IFZVxdbQKdiNTBqRpVWzu
cYFedKfe3PWysyIdn3LBgKiSnb4SGh5KXcs/gPJNWdrx+X/UGa1ThCjTItpQRhiX
rordKoFXN49xOXPgGAW4lnlwIC0XpfKTc6NHmF+VfMYBYp3issbQ2XqAXgLD59ag
F4gOi3CbPQ8nOF99clypRtbtOfxLa/B9zi5aO97QnvFRnOwnGjiDMurAUh6suIxv
kmzzFNsFEUd9WzV9liCWa21Ou5UX99GT+f/V69kGSDLefgz08a0PXwELvFExQXA=
=NWYk
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Apr_2011_11_10_24_+1000_CaGiVFLmEu3.v/WU--
