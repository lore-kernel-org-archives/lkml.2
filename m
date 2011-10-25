Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1JYH2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:28:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59870 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1JYH2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:28:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Greg KH <greg@kroah.com>
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
In-Reply-To: Your message of "Tue, 25 Oct 2011 03:49:11 +0200."
             <20111025014911.GC22764@kroah.com>
From: Valdis.Kletnieks@vt.edu
References: <4EA3F7C0.24E469C5@users.sourceforge.net> <20111023113727.GA24285@kroah.com> <4EA41FB7.CB5369CF@users.sourceforge.net>
            <20111025014911.GC22764@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319527717_3131P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 03:28:37 -0400
Message-ID: <11749.1319527717@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4EA66520.013F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319527717_3131P
Content-Type: text/plain; charset=us-ascii

On Tue, 25 Oct 2011 03:49:11 +0200, Greg KH said:

> The real check, to verify that this tarball really came from "me" should
> be done on the uncompressed tarball, which is what I can sign, and it is
> something that you, or anyone else, can reliable duplicate on their own
> by just using git and not even downloading the tarball at all.

I'm OK on that part..

> In other words, we just saved you a MASSIVE bandwidth transation for all
> of your future kernel downloads, and you can reliable know that the
> tarball you have in your system is what is on the kernel.org servers
> without you even having to download it yourself and run those
> decompression tools that you don't trus.

If you're building an automated process that will take a just-uploaded foo.tar
and generate foo.tar.{bz2,gz,foozip}, can you add a step that would just do an
'md5sum foo.tar.* > foo.tar.sums'?  Or sha256sum if you're worried about the
crypto weakness issues with MD5. Personally, I'm more interested in the "Did  I
hit a network error that the TCP checksum didn't catch?" case.

No hurry, I know what a beast it can be to redesign systems of this scale.  Just
a would-be-nice...


--==_Exmh_1319527717_3131P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpmUlcC3lWbTT17ARAtapAJ48XVVwoOk1HJ3pmEj/tLoK/ze4QQCfV3ni
eAnGUeUyir8kQy5Gl0+4qcM=
=XcRK
-----END PGP SIGNATURE-----

--==_Exmh_1319527717_3131P--

