Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab1D2SaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:30:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49963 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab1D2SaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:30:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Michal Marek <mmarek@suse.cz>
Cc: bp@alien8.de, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
In-Reply-To: Your message of "Fri, 29 Apr 2011 15:31:33 +0200."
             <1304083893-18849-1-git-send-email-mmarek@suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <71633.1304013549@localhost>
            <1304083893-18849-1-git-send-email-mmarek@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304101756_56837P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Apr 2011 14:29:16 -0400
Message-ID: <154241.1304101756@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4DBB0380.0162,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304101756_56837P
Content-Type: text/plain; charset=us-ascii

On Fri, 29 Apr 2011 15:31:33 +0200, Michal Marek said:
> Add support for make W=12, make W=123 and so on, to enable warnings from
> multiple W= levels. Normally, make W=<level> does not include warnings
> from the previous level.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---

OK, that addresses my concerns, feel free to stick a
Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
on it...

--==_Exmh_1304101756_56837P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNuwN8cC3lWbTT17ARAkx5AKCJib5sgQzMUF+G3aXr0VsH9Esp9QCgqvts
ZF+QLPT+THUboTn6f112/5A=
=sFfW
-----END PGP SIGNATURE-----

--==_Exmh_1304101756_56837P--

