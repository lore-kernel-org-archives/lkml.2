Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0CZP6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:58:43 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59584 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0CZP6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:58:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Wolfram Sang <w.sang@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in soc_common.c
In-Reply-To: Your message of "Wed, 24 Mar 2010 20:20:19 -0300."
             <cecb6d8f1003241620v55fb960ds14818bf3a03fa334@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <20100324230729.GA21359@n2100.arm.linux.org.uk>
            <cecb6d8f1003241620v55fb960ds14818bf3a03fa334@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1269618994_4209P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Mar 2010 11:56:34 -0400
Message-ID: <10080.1269618994@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4BACD935.0283,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1269618994_4209P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Mar 2010 20:20:19 -0300, Marcelo Jimenez said:

>> - =A0 =A0 debug(skt, 2, =22mask: %s%s%s%s%s%sflags: %s%s%s%s%s%sVcc %d=
 Vpp %d irq %d=5Cn=22,

> I will redo it, no problem. But just for my information, in that
> particular case, is it usefull to grep using format specifiers?

Until you find the format string, you really don't know for sure if
it's a %d or a %u or a %alt-ctl-cokebottle so you end up grepping like th=
is:

egrep 'mask: .*flags: .*Vcc .* Vpp .* irq'

basically wildcarding your way across whatever %foo might be there.

--==_Exmh_1269618994_4209P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLrNkycC3lWbTT17ARAvw8AJ0fkJ9pFeGhInoowQnCeXMbzvfw/gCgq0Oo
mUp/GoaATxy6mPCt6nOE6fo=
=2pV/
-----END PGP SIGNATURE-----

--==_Exmh_1269618994_4209P--

