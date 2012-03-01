Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab2CAC4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:56:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35905 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab2CAC4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:56:11 -0500
Date: Thu, 1 Mar 2012 13:56:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: build failure after merge of the cpufreq tree
Message-Id: <20120301135601.a164a12e2bd4aee871ff60db@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Mar_2012_13_56_01_+1100_xnmvDPfHlmP+sEiN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Mar_2012_13_56_01_+1100_xnmvDPfHlmP+sEiN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the cpufreq tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/cpufreq/cpufreq_ondemand.c: In function 'cpufreq_gov_dbs_init':
drivers/cpufreq/cpufreq_ondemand.c:880:28: error: 'PM_QOS_DVFS_RESPONSE_LAT=
ENCY' undeclared (first use in this function)
drivers/cpufreq/cpufreq_ondemand.c: In function 'cpufreq_gov_dbs_exit':
drivers/cpufreq/cpufreq_ondemand.c:896:25: error: 'PM_QOS_DVFS_RESPONSE_LAT=
ENCY' undeclared (first use in this function)

Caused by commit 500e8ca39c56 ("[CPUFREQ] ondemand: handle QoS request on
DVFS response latency").

I have used the cpufreq tree fomr next-20120229 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Mar_2012_13_56_01_+1100_xnmvDPfHlmP+sEiN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTuVBAAoJEECxmPOUX5FE0KoQAJN10wJOK9G7jeRbsErHIgs5
lLMs/Z7ThIgkG/lNVPiDwg52DusqqiCemHH0J5rzzq2vTv0XKyEFzoc+aRgx6p7g
zqXx+0m/9by9Oy/MDLWOL6hIXp8bFz92APqcThV/NP40uCClVydrgWyLEdd+zthz
uUOrdjMQI0r4J13fG/OUpbVWARcQUNDFH3NfTjH0w55ImFIexKanx8LM3hmDZgoV
TbzbFOI4etwRWcGhqwVIWzSHG5waDacJ8Tew/jUUoP1ESjx9dMg4VtVxcHazSPpk
mbJT/OlcnbCcV27P2HWg35dVRjf2qPZTkdorPXHVIm8zQ/AaIvSRj/68Dqsd+Xth
FOf9m2z60AkhNGXsERNipiB1feqIqbFVeuvi1f2LvSGDtPBg1qwqrBheGqfr3ZQi
8+ce5GvSWl98e5kHiiAGF8OCdGD0oT0vjSYeUdnYHbmQbb5Lu5bK30GNZbugx8h7
wo1V43ew9IR01By18jZROKhDPta3rEwFXqMvsDpjtU2DCVyRR5HJSgeOQ1/oN7G8
YV2Laj04+mr5XVuab1VNAbuAl3likw3nvnV8kGz0okj8RhOt2VxxclOC7rdPi5WC
F7KsZt8QKmCZSY39mUTuqvMrvlJaeEt2l9bkCigFspwJ5Ig6Yeok57JAcBo8VV/J
uwrpeX/96FwRBJ9ccGY7
=KF+1
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Mar_2012_13_56_01_+1100_xnmvDPfHlmP+sEiN--
