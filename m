Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1JYJOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:14:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56683 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab1JYJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:14:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle Moffett <kyle@moffetthome.net>, Greg KH <greg@kroah.com>,
        Jari Ruusu <jariruusu@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
In-Reply-To: Your message of "Tue, 25 Oct 2011 10:27:05 +0200."
             <4EA672D9.106@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <4EA3F7C0.24E469C5@users.sourceforge.net> <20111023113727.GA24285@kroah.com> <4EA41FB7.CB5369CF@users.sourceforge.net> <20111025014911.GC22764@kroah.com> <CAGZ=bqKvb96VvZ5a+VJWZXKdr553n8SW2=JOLZS1fGY5KE7iZg@mail.gmail.com>
            <4EA672D9.106@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319534028_3131P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 05:13:48 -0400
Message-ID: <15483.1319534028@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4EA67DD0.008F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319534028_3131P
Content-Type: text/plain; charset=us-ascii

On Tue, 25 Oct 2011 10:27:05 +0200, "H. Peter Anvin" said:

> It would be a very good thing for people to develop tools to run
> compressors and decompressors in locked-down boxes.  It should be
> possible to run these kinds of programs without access to either network
> or filesystem; only read from stdin and out on stdout (and presumably
> stderr for errors.)  This would solve problems for much more than just
> kernel.org.

Wasn't there once a kernel hack called seccomp, that only allowed read syscalls
on stdin and writes on stdout and that was it? ;)


--==_Exmh_1319534028_3131P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpn3McC3lWbTT17ARAgrKAKDacCJN5r9YbAqcoXgleL3QfuveEQCgzrzP
fmRiUF0NwcQ66D3gdQBM9ro=
=P610
-----END PGP SIGNATURE-----

--==_Exmh_1319534028_3131P--

