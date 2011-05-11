Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1EKQXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:23:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60109 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab1EKQXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:23:02 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Marco Weber <marco.weber@uni-trier.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with procfs
In-Reply-To: Your message of "Tue, 10 May 2011 11:26:43 +0200."
             <4DC904D3.1010906@uni-trier.de>
From: Valdis.Kletnieks@vt.edu
References: <4DC904D3.1010906@uni-trier.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305130977_2793P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 11 May 2011 12:22:57 -0400
Message-ID: <13888.1305130977@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DCAB7E2.0187,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305130977_2793P
Content-Type: text/plain; charset=us-ascii

On Tue, 10 May 2011 11:26:43 +0200, Marco Weber said:

> As you see the directory has 500 permissions. ( On all other machines 
> the /proc has 555 permissions. )

> This is the kernel that is running:
> root@m88:~# uname -a
> Linux m88 2.6.38.2-grsec-xxxx-grs-ipv6-64 #1 SMP Fri Apr 15 17:44:15 UTC 

Aha.  "grsec".

You run a kernel with grsecurity compiled in, this sort of stuff happens by design.

--==_Exmh_1305130977_2793P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNyrfhcC3lWbTT17ARAqbcAJ4kSPCWe+1IAa1O29OdlZXkQ6nkGACdE/uY
sTMypm8CY2YjI3zbyJpsJC0=
=SwtB
-----END PGP SIGNATURE-----

--==_Exmh_1305130977_2793P--

