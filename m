Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1IWWPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:15:03 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48830 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1IWWPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:15:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, mingo@elte.hu,
        dsahern@gmail.com, robert.richter@amd.com, ak@linux.intel.com
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
In-Reply-To: Your message of "Fri, 23 Sep 2011 11:03:20 +0300."
             <CAOJsxLE1L1ffZmuF+2+vYZMTXyvq00pOcP1xvGJuW0TqxQskrA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20110922123128.GA9761@quad> <CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com> <CABPqkBQSBKS+bnLhStzV4PTrE+Qrb1XyeR5FEyn4d+NFZrhuOQ@mail.gmail.com>
            <CAOJsxLE1L1ffZmuF+2+vYZMTXyvq00pOcP1xvGJuW0TqxQskrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316815985_33036P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Sep 2011 18:13:05 -0400
Message-ID: <35021.1316815985@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E7D0474.002E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316815985_33036P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 22, 2011 at 3:31 PM, Stephane Eranian <eranian=40google.com> =
wrote:
> =23 CPU0 sibling cores =A0: 0-3
> =23 CPU0 sibling threads: 0
> =23 CPU1 sibling cores =A0: 0-3
> =23 CPU1 sibling threads: 1
> =23 CPU2 sibling cores =A0: 0-3
> =23 CPU2 sibling threads: 2

On Fri, 23 Sep 2011 11:03:20 +0300, Pekka Enberg said:
> Well, sure but it blocks rest of the interesting information too. It se=
ems to me
> that the CPU information could be truncated to some sane limit by defau=
lt and
> introduce a command line option for users that really want to see all o=
f it.

Too bad there's probably no easy way to provide an iterator/metafunction =
that
describes the CPUs, so it could output=20

=22for n in 0..4095 cpu=5Bn=5D looks like this:=20
   CPU_n sibling cores: round(n,4)..round(n,4)+3
   CPU_n sibling threads: n...

--==_Exmh_1316815985_33036P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfQRxcC3lWbTT17ARAl/xAKDnFdyq81Dn1KOYctRN/JWAfk8oowCfZbQv
XtAHY3DVTOpIduxZVQrv2VE=
=tDNl
-----END PGP SIGNATURE-----

--==_Exmh_1316815985_33036P--

