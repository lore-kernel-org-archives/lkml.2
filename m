Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0CYS3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:29:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57988 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0CYS3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:29:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
       linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in soc_common.c
In-Reply-To: Your message of "Thu, 25 Mar 2010 13:19:29 +0300."
             <4BAB38B1.8080404@ru.mvista.com>
From: Valdis.Kletnieks@vt.edu
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <20100324230729.GA21359@n2100.arm.linux.org.uk>
            <4BAB38B1.8080404@ru.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1269541561_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Mar 2010 14:26:01 -0400
Message-ID: <9610.1269541561@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=50/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=bulk(0),
	refid=str=0001.0A02020A.4BAB9D45.00E0,ss=3,sh,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1269541561_3923P
Content-Type: text/plain; charset=us-ascii

On Thu, 25 Mar 2010 13:19:29 +0300, Sergei Shtylyov said:

>    I'd disagree in this case. Anybody will hardly grep for "mask: 
> %s%s%s%s%s%sflags: %s%s%s%s%s%s".

However,  egrep 'mask: .*flags: ' is quite plausible.

--==_Exmh_1269541561_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLq6q5cC3lWbTT17ARAhj0AKDLRN8K9V67SKHKiokHG2Knw/+l9gCfWm78
Yy8mKyjThNBl8PkKR5tLh7c=
=+F89
-----END PGP SIGNATURE-----

--==_Exmh_1269541561_3923P--

