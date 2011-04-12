Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1DLD0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 23:26:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60554 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab1DLD0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 23:26:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Michal Marek <mmarek@suse.cz>
Cc: jwjstone@fastmail.fm, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: Allow to override LINUX_COMPILE_BY and LINUX_COMPILE_HOST macros
In-Reply-To: Your message of "Mon, 11 Apr 2011 17:04:49 +0200."
             <1302534289-17689-1-git-send-email-mmarek@suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <4D9B3AA4.5090402@fastmail.fm>
            <1302534289-17689-1-git-send-email-mmarek@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302578757_5348P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 11 Apr 2011 23:25:57 -0400
Message-ID: <18001.1302578757@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DA3C646.00D5,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302578757_5348P
Content-Type: text/plain; charset=us-ascii

On Mon, 11 Apr 2011 17:04:49 +0200, Michal Marek said:
> Make it possible to override the user@host string displayed during boot
> and in /proc/version by the environment variables KBUILD_BUILD_USER and
> KBUILD_BUILD_HOST. 

> +
> +KBUILD_BUILD_TIMESTAMP

Changelog section doesn't match actual patch.  Other than that, I'm OK on this.

--==_Exmh_1302578757_5348P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNo8ZFcC3lWbTT17ARAn/tAKDPK4FWOpL/gBSB8dVtjuLJBYN9AACgg0qg
oTXNm96m8yN3jUTHNWA+5wo=
=gslI
-----END PGP SIGNATURE-----

--==_Exmh_1302578757_5348P--

