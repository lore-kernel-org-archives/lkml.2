Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1IPTUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:20:38 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34339 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab1IPTUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:20:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: x86@kernel.org,
        SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Willy Lambert <lambert.willy@gmail.com>
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64 systems
In-Reply-To: Your message of "Fri, 16 Sep 2011 11:22:45 +0200."
             <4E731565.5050307@grandegger.com>
From: Valdis.Kletnieks@vt.edu
References: <4E731565.5050307@grandegger.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316200771_55056P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Sep 2011 15:19:31 -0400
Message-ID: <63081.1316200771@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E73A144.013A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316200771_55056P
Content-Type: text/plain; charset=us-ascii

On Fri, 16 Sep 2011 11:22:45 +0200, Wolfgang Grandegger said:
> There are 64-bit systems out there, like the ATOM N450, which
> have ISA slots.

That's a scary thought...

> +if X86_32
> +
>  config EISA

But not as scary as the implication that the N450 has ISA but *not* EISA??!?

--==_Exmh_1316200771_55056P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOc6FDcC3lWbTT17ARAuQfAJwJoFYo8r9zlpeLuJfpNZ2ZELFOsACfYGf3
D+kbupzgHF+SQ03SfjmDzmw=
=fVwE
-----END PGP SIGNATURE-----

--==_Exmh_1316200771_55056P--

