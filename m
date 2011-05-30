Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab1E3SLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:11:47 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49459 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab1E3SLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:11:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Rohit Yadav <rohityadav89@gmail.com>
Cc: len.brown@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Arch: x86: process: Fix a compilation warning.
In-Reply-To: Your message of "Mon, 30 May 2011 23:28:47 +0530."
             <BANLkTim2yJkQG=2JzFwxcAUfB3HF_m52Rg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <rohityadav89@gmail.com> <1306776629-13404-1-git-send-email-rohityadav89@gmail.com> <11791.1306777203@turing-police.cc.vt.edu>
            <BANLkTim2yJkQG=2JzFwxcAUfB3HF_m52Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306779099_2897P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 30 May 2011 14:11:39 -0400
Message-ID: <13206.1306779099@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DE3DDDB.010A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306779099_2897P
Content-Type: text/plain; charset=us-ascii

On Mon, 30 May 2011 23:28:47 +0530, Rohit Yadav said:

> Attached: New patch.

Still needs help:

> Remove unknown escape sequence \i in idle_setup.

> -		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
> +		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012.\n");

Changelog should say "Fix mismatched escaped quotes to resolve compiler warning" or
similar. You should explain *what* the patch does (fix the quotes) and *why*
(because it's broken and won't compile).


--==_Exmh_1306779099_2897P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN493bcC3lWbTT17ARAoKXAKDeZILoQTDQO53hPQnOoKTyJDNlaQCdFuQt
5V0fa61dgUFAlOpswwTXSY8=
=GDLT
-----END PGP SIGNATURE-----

--==_Exmh_1306779099_2897P--

