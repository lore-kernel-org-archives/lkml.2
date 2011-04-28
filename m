Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1D1AQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:16:17 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50092 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1D1AQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:16:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
In-Reply-To: Your message of "Wed, 27 Apr 2011 12:08:28 BST."
             <1303902508.15101.21.camel@e102109-lin.cambridge.arm.com>
From: Valdis.Kletnieks@vt.edu
References: <201104212129.17013.arnd@arndb.de> <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com> <201104271243.16868.arnd@arndb.de>
            <1303902508.15101.21.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1303949729_5598P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Apr 2011 20:15:29 -0400
Message-ID: <11431.1303949729@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4DB8B1A5.0007,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1303949729_5598P
Content-Type: text/plain; charset=us-ascii

On Wed, 27 Apr 2011 12:08:28 BST, Catalin Marinas said:

> The current version of the ARM ARM says "unpredictable". But this
> general definition of "unpredictable" does not allow it to deadlock
> (hardware) or have security implications. It is however allowed to
> corrupt data.

Not allowed to have security implications, but is allowed to corrupt data.

*boggle* :)

(The problem being, of course, that if the attacker is able to predict/control
what gets corrupted, it can easily end up leveraged into a security implication.)

--==_Exmh_1303949729_5598P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNuLGhcC3lWbTT17ARAofNAKCJq4YPwOGDwFc4TQEhpvtA36neHgCg2eAm
0Y4V85ENPqLJXiYPkjcjruY=
=j/Ko
-----END PGP SIGNATURE-----

--==_Exmh_1303949729_5598P--

