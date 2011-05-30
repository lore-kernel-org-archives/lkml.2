Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab1E3PI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 11:08:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35494 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1E3PI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 11:08:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] kbuild: Fix <linux/version.h> for X.Y versions
In-Reply-To: Your message of "Mon, 30 May 2011 16:50:50 +0200."
             <1306767052-15593-3-git-send-email-mmarek@suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <1306767052-15593-1-git-send-email-mmarek@suse.cz>
            <1306767052-15593-3-git-send-email-mmarek@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306768129_2897P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 30 May 2011 11:08:49 -0400
Message-ID: <5164.1306768129@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DE3B302.0161,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306768129_2897P
Content-Type: text/plain; charset=us-ascii

On Mon, 30 May 2011 16:50:50 +0200, Michal Marek said:

> +	expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + 0$(SUBLEVEL));    \

expr isn't going to interpret that last field as octal, is it?

--==_Exmh_1306768129_2897P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN47MBcC3lWbTT17ARAjs8AKDuRh/ZlXbZuvJAx9aur73aDQAgNgCgqpe1
oNA5NbC+ZtkyW6R9aAX6sGQ=
=nC+B
-----END PGP SIGNATURE-----

--==_Exmh_1306768129_2897P--

