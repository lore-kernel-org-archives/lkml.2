Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1HQWv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 18:51:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53176 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1HQWvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 18:51:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Pavel Ivanov <paivanof@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: make driver usable standalone
In-Reply-To: Your message of "Wed, 17 Aug 2011 18:25:49 +0200."
             <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com> <CA+XFjipM1Qup3bcJos_ikwzoaWoa3GdYqK0WBUqEHBNR6V6LfQ@mail.gmail.com> <CAG1a4rsyfPrrrf-mzt3HAM6YHHjaHTcd2rbtYiwqLkUCP=j8pQ@mail.gmail.com>
            <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313621503_2796P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Aug 2011 18:51:43 -0400
Message-ID: <24649.1313621503@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4E4C4601.001B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1313621503_2796P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Aug 2011 18:25:49 +0200, G=E1bor Stefanik said:

> Iwconfig and iwlist are themselves deprecated. Iw is the new wireless
> configuration tool.

Somebody better tell Fedora Rawhide - as of the version released on July =
27,
their 'initscripts' RPM was still using iwconfig in /etc/sysconfig/networ=
k-scripts/ifup-wireless

So don't be quite so fast to be declaring WIRELESS_EXT dead just yet.




--==_Exmh_1313621503_2796P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOTEX/cC3lWbTT17ARAjg9AJ9Ckfb5IVaCA4QdDju5VfQW8oMkGACfR062
XU0l08rRaB1BntJQSSM2Yx8=
=mtz8
-----END PGP SIGNATURE-----

--==_Exmh_1313621503_2796P--

