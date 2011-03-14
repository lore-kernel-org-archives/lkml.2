Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1CNT5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:57:33 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45700 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab1CNT5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:57:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Justin <wellspring3@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: milw0rm rootkit
In-Reply-To: Your message of "Mon, 14 Mar 2011 12:28:11 PDT."
             <AANLkTimE94jf0N54c5ijKUs3Ln_hhNUuCecuda98y2O9@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTim9jsGz=ELPNUVJHWN8Z4EzBrFA03XXt_QYPsEh@mail.gmail.com> <20110314190813.GC20259@home.goodmis.org>
            <AANLkTimE94jf0N54c5ijKUs3Ln_hhNUuCecuda98y2O9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1300132649_5270P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Mar 2011 15:57:29 -0400
Message-ID: <37114.1300132649@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4D7E732A.00E6,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1300132649_5270P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Mar 2011 12:28:11 PDT, Justin said:
> Yes, she runs 2.6.34.8-68.fc13.i686.PAE

Which is the most recently released Fedora 13 kernel, from Feb 24,
so not ancient...

> I know this is for the kernel... The C file seems to exploit a
> vulnerability in the kernel, so I thought I should let the kernel
> people know so they could patch it upstream.

Toss the .c file to 'security@kernel.org', that's what it's there for.
If you have enough kernel savvy to figure out what's getting abused,
cc: the subsystem maintainer.  But if you don't, that's OK too,
somebody reading security@ will handle that if needed.


--==_Exmh_1300132649_5270P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNfnMpcC3lWbTT17ARAkroAJ9heg3Lck9WJqTnVddMzvws3Ar+kgCfUQUx
7yNsjY8Kuvundu+YiDTm8x4=
=jmhl
-----END PGP SIGNATURE-----

--==_Exmh_1300132649_5270P--

