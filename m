Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161835Ab2CSRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:24:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39161 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab2CSRY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:24:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: David Howells <dhowells@redhat.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: triage for March 18, 2012
In-Reply-To: Your message of "Mon, 19 Mar 2012 15:21:31 -0000."
             <9942.1332170491@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1121.1332169437@redhat.com> <20120318235114.GA30497@thor.bakeyournoodle.com> <20120318184105.GC2095@windriver.com>
            <9942.1332170491@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332177826_2016P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Mar 2012 13:23:46 -0400
Message-ID: <161084.1332177826@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4F676BA4.0160,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332177826_2016P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Mar 2012 15:21:31 -0000, David Howells said:

> Here's a patch I got from Nick Clifton to fix 64-bit binutils to handle
> representing things like 0xfffffff1 as a 32-bit negative immediate argument.
> It has been applied upstream.

> ! #if 1
> !       /* Handle the case where a hex value is parsed on a 64-bit host.
> ! 	 A value like 0xffffe000 is clearly intended to be a negative
> ! 	 16-bit value, but on a 64-bit host it will be parsed by gas
> ! 	 as 0x00000000ffffe000.

Umm.. it's not clear to *me* that it's intended to be a negative 16 bit?  Or am I just
missing context not present in the patch?

(I have no idea if the rest of the patch is OK or not, but that comment didn't give
me warm fuzzies....)

--==_Exmh_1332177826_2016P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2drogdmEQWDXROgAQJ3+Q/+ONWQ21FC6TFhSooAMh+yuI1H7E5aFSe9
gzivKeuBgNewkp187z9AY5JVLAckY7FtKf3Lvhfm2hnlVD6SETI5QRRq905v5rwr
wlyw+vLxaJi8uCwdw4NiEOFcXYAAB2DjZgNPt1Lps4K+6JTs+9aIJebxh/pl/Fgw
2+Nguhs1as4AOcZ3OTXvQI/tUakCXZtWy54xjSVZ6sR5+vaJnt8rs8ztQMU5CfM/
ISZ98ATaKXZ+2rj10+jUo9XdGN/dqXzQVZJYaWqv86f5crPXT1T/DAdNjr1UdepL
wlAtaAQ2XvXLmhLjeHLpnK0vnzCPvsCB4LYWVcBSIVv2r1OEAxf0nvKOFpxV0Ao0
tC3RUrA6LMSSBAUYJDOljLQMbTzSqiotMmdQwYgqNxY9ppw9GFeHi7C+jiYKAPH2
EBdfdGAjJINA2sKaIMwqg7c7HN7krCEEDd/b+XNblmTBgXtjYnkf5xUGLvP2+i4C
ZG09/kKwJXVPyiRjLuaiqGK3UKWQ0EL5wqkIJFhGUaewJlMoWVebq2OxMJRInDu2
6SRJx3XT54/wpOjLW1Hsa1YIlW9YfuitcULR1Bv2ASe3gpg7qSeAALnf3moyNZNc
vgrJEXEb/YYVtxSp2jnKw6gDE57xjqT/OBH/l2U4kuvyB1khMguI6Ksek+Q+pBLI
402x7/3NlGw=
=yYHT
-----END PGP SIGNATURE-----

--==_Exmh_1332177826_2016P--

