Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1JXRSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:18:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56966 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab1JXRSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:18:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Greg KH <greg@kroah.com>
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
In-Reply-To: Your message of "Sun, 23 Oct 2011 13:37:27 +0200."
             <20111023113727.GA24285@kroah.com>
From: Valdis.Kletnieks@vt.edu
References: <4EA3F7C0.24E469C5@users.sourceforge.net>
            <20111023113727.GA24285@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319476703_2592P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Oct 2011 13:18:23 -0400
Message-ID: <9267.1319476703@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4EA59DE1.007A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319476703_2592P
Content-Type: text/plain; charset=us-ascii

On Sun, 23 Oct 2011 13:37:27 +0200, Greg KH said:
> If you are really worried about decompressor bugs, then run them in a
> virtual machine/chroot :)

Of more concern than bugs are errors during download.  Yes, TCP has a checksum,
which is a CRC that quite frankly sucks when we're talking the amount of data
that kernel.org moves. So there's a non-zero chance you'll get bad data
downloaded.  And you really want to do a more effective data check  (MD5 or SHA
sum, or a PGP signature) *before* you decompress, in case the corrupted data
causes a spew of gigabytes of trash and fills your filesystem.


--==_Exmh_1319476703_2592P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpZ3fcC3lWbTT17ARAiw1AKCPFIrZ8G40pexrkL2rQhGFJP0nVwCfQSoc
RYyBR/rFOLsPjWpx2RHAKNo=
=TlcJ
-----END PGP SIGNATURE-----

--==_Exmh_1319476703_2592P--

