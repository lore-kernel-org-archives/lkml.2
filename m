Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab1EBWWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:22:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:38239 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1EBWWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:22:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mike Waychison <mikew@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-firmware tree
In-Reply-To: Your message of "Mon, 02 May 2011 14:40:33 PDT."
             <BANLkTinTUdAgF4eQ8_JtWgT_jJB5f7nT-A@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTimmr=rD84cAkQ2xGsG7PccxQKKqVg@mail.gmail.com> <1304365095.6400.20.camel@macbook.infradead.org>
            <BANLkTinTUdAgF4eQ8_JtWgT_jJB5f7nT-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304374925_5156P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 May 2011 18:22:05 -0400
Message-ID: <33956.1304374925@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DBF2E8E.00CF,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304374925_5156P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 May 2011 14:40:33 PDT, Mike Waychison said:

> I don't see anything in the build (looking at scripts/Makefile.fwinst
> in particular) that allows the build to enumerate out-of-tree firmware
> files required by drivers.  Do you have any thoughts on how this could
> be enumerated? (if it isn't already?)

MODULE_FIRMWARE tags in the drivers, combined with (possibly)
the CONFIG_EXTRA_FIRMWARE and CONFIG_EXTRA_FIRMWARE_DIR
Kconfig variables if the needed bits aren't in /lib/firmware?

--==_Exmh_1304374925_5156P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNvy6NcC3lWbTT17ARAumOAJ9ZrsveQ4vz7fLg5i6xd3TXjmgqCACg96NO
jpz5f5bLspLM+vYIQ4v22mw=
=rQlF
-----END PGP SIGNATURE-----

--==_Exmh_1304374925_5156P--

