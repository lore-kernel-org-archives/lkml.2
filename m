Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1JNTLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:11:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45966 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1JNTLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:11:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] cris: drop unused Kconfig symbols
In-Reply-To: Your message of "Fri, 14 Oct 2011 15:33:54 +0200."
             <20111014133354.GE9412@axis.com>
From: Valdis.Kletnieks@vt.edu
References: <1318595467.6132.80.camel@x61.thuisdomein>
            <20111014133354.GE9412@axis.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318619461_2815P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Oct 2011 15:11:01 -0400
Message-ID: <14215.1318619461@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E988946.00C0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318619461_2815P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 Oct 2011 15:33:54 +0200, Jesper Nilsson said:
> Hmmm... NAK on that. Lots of these configs are actually used, but in drivers
> not upstream yet (serial port, ethernet and usb drivers for ARTPEC-3).

Shouldn't the patches that upstream those drivers be the ones to add the
Kconfig glue?  Or is this a case of "in-flight driver" where the submission is
literally in the middle of getting merged so some parts have landed and some
haven't yet, and all will be good in the next merge cycle?

(Personally, I'm tending towards unless it's going to be in linux-next within
the next month or so, pull the Kconfig variables out and the driver can re-add
them when it actually lands)


--==_Exmh_1318619461_2815P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOmIlFcC3lWbTT17ARArMvAJ9/y+wrx74Fe0ClAk5aGqRBhANFXACgocSS
W9SBvj5V9XLaFeJenKzpeHs=
=A2fn
-----END PGP SIGNATURE-----

--==_Exmh_1318619461_2815P--

