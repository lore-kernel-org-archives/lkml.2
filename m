Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966Ab2FAVtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:49:49 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43449 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2FAVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:49:47 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: =?UTF-8?B?wqA=?= <porpen@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Anyone successfully booted a custom kernel on Fedora 17?
In-Reply-To: Your message of "Fri, 01 Jun 2012 05:49:57 -0400."
             <CAANzHtSHRXkYJcBRBvCRPj_KR-q3qSUa6xNNmFDLHB-ixDMv9w@mail.gmail.com>
From: valdis.kletnieks@vt.edu
References: <4FC6B85C.20201@candelatech.com> <4FC6E257.4070608@candelatech.com> <23353.1338510488@turing-police.cc.vt.edu> <4FC810B3.5040208@candelatech.com>
            <CAANzHtSHRXkYJcBRBvCRPj_KR-q3qSUa6xNNmFDLHB-ixDMv9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1338587383_2041P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Jun 2012 17:49:43 -0400
Message-ID: <17788.1338587383@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.161.180 mail-gg0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4FC938FA.0090,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1338587383_2041P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 01 Jun 2012 05:49:57 -0400, =A0 said:

> This thread might help you folks.
> http://lkml.org/lkml/2012/5/18/230
> Urgent: x86-32 and GNU ld 2.22.52.0.1

x86_64 here, so I doubt that's the problem. That, and both my working and=

broken kernels were build with binutils 2.22.52.0.3 - working with gcc 4.=
6.2
and busted with 4.7.0.

--==_Exmh_1338587383_2041P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT8k49wdmEQWDXROgAQJe7hAAmAZCKqlkQssK2u2Jk9UjrGeJWZUemeY+
x+FQazHPtJB6imYgr1KBSDi0M7c//3CY3gL1eh4YMPna8XGBt56BRIkj5RmxH1YG
XEE9aAXcUacNsPVcPSd6bS3pKLhtlphJqLXJTBTmnX7K2I1ib4V/+LwjfW6Bx5At
Jf+XNswCu8fVV2EdyPtVrxUrczQyZTz+nBE4AeDR5u+oq5l+80L8ZfjO+6yuy28Y
0zDyfpaO7eygfhKoyoarIVTMwc3va6OFAbFzjwr3Ph9vupfp+jg22d2yGVGDRyTl
asXSuyLWpHlYSR+RmySBinehUinkLLcJpCcGF9DFyDasUKc7FUb74hf/LfxnO1qF
jzTApGGGXxESkEzo4indMPKiGR8GWlT293QQ5qgj+oRkBJofx7Vs0S45mHdnrDzz
jwAdzOCagtQQVwB9Qen0khh02boRfJUXkbk1g18EzMzzbCkeLnuk0w6v7JhTbXT3
Pza+hkIxikcJ0HZ8hHUr8ee9uBbHz/xa19DTMpi93wskYkMAaFOCl807rZSMTlYu
TRuqAWtHGsEP+ILskuztf38qeVWEO7Gv9IbvVfAHgLdMl0Zl7FCZTrOUjWUM3jog
M3N4Jv+UhQjliC0kanJAZ+2Igt/q8E98MSAyLtwjYiSakincnrRNf2eGDM32iivj
igdoRLCrKb8=
=Mr7T
-----END PGP SIGNATURE-----

--==_Exmh_1338587383_2041P--

