Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1IPRyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:54:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49457 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1IPRyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:54:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mandeep Singh Baines <msb@chromium.org>
Cc: dm-devel@redhat.com, Will Drewry <wad@chromium.org>,
        Elly Jones <ellyjones@chromium.org>,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: verity target
In-Reply-To: Your message of "Thu, 15 Sep 2011 11:45:59 PDT."
             <1316112359-6085-1-git-send-email-msb@chromium.org>
From: Valdis.Kletnieks@vt.edu
References: <1316112359-6085-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316195647_55056P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Sep 2011 13:54:07 -0400
Message-ID: <59032.1316195647@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E738D41.0178,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316195647_55056P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Sep 2011 11:45:59 PDT, Mandeep Singh Baines said:
> The verity target provides transparent integrity checking of block devices
> using a cryptographic digest.

I just had this mental image of Dr Henry Jones saying: "But in Latin, verify is
spelled with an f..." ;)

Might want to add something to device-mapper/dm-verity.txt explaining
where the name came from and that it's *not* a typo?

--==_Exmh_1316195647_55056P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOc40/cC3lWbTT17ARAlK+AJ96GzzZqE0XRLQrD5o7WPkv2HFZiQCeK8PD
2R1jQZha0QSRetnPI+wPOzM=
=SWTW
-----END PGP SIGNATURE-----

--==_Exmh_1316195647_55056P--

