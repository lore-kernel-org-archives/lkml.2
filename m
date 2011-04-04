Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab1DDMqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:46:12 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56655 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1DDMqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:46:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig to Makefile
In-Reply-To: Your message of "Mon, 04 Apr 2011 13:40:51 +0300."
             <1301913651-9055-2-git-send-email-dedekind1@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1301913651-9055-1-git-send-email-dedekind1@gmail.com>
            <1301913651-9055-2-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1301921158_92930P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Apr 2011 08:45:58 -0400
Message-ID: <131611.1301921158@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D99BD89.0081,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1301921158_92930P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Apr 2011 13:40:51 +0300, Artem Bityutskiy said:

> 3. By default KALLSYMS_EXTRA_PASS is disabled and if kallsyms has issues,
>    "make" should print a warning and suggest using KALLSYMS_EXTRA_PASS

If the Makefile has enough information to print the warning, why can't it go
ahead and do the extra pass itself instead of issuing the warning?

(I'm obviously missing something here, as I'm foolishly posting to lkml before
caffeine ;)


--==_Exmh_1301921158_92930P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNmb2GcC3lWbTT17ARAloDAKD+x1wg/vN9qk/rvfpcBG42d0cszACfRXyJ
kXlTDEMJ28XKz6VNmbypuvo=
=gnYt
-----END PGP SIGNATURE-----

--==_Exmh_1301921158_92930P--

