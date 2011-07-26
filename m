Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab1GZSIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:08:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36299 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1GZSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:08:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Doron Cohen <doronc@siano-ms.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FW: [PATCH] drivers: support new Siano tuner devices.
In-Reply-To: Your message of "Sun, 24 Jul 2011 10:39:00 +0300."
             <D945C405928A9949A0F33C69E64A1A3BB00473@s-mail.siano-ms.ent>
From: Valdis.Kletnieks@vt.edu
References: <D945C405928A9949A0F33C69E64A1A3BAFFC4B@s-mail.siano-ms.ent> <32054.1311294764@turing-police.cc.vt.edu>
            <D945C405928A9949A0F33C69E64A1A3BB00473@s-mail.siano-ms.ent>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1311703682_2745P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Jul 2011 14:08:02 -0400
Message-ID: <36863.1311703682@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E2F0283.012D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1311703682_2745P
Content-Type: text/plain; charset=us-ascii

On Sun, 24 Jul 2011 10:39:00 +0300, Doron Cohen said:

> I guess the right thing is to have the copyrights to Siano since legally
> - we are all signed on a contract which specifies all our code as
> company property. 
> But if changing the copyright is an issue - we will leave it unchanged.

In that case, a patch that did the following:

1) Mentioned the contract status of the code in the changelog section
2) Looked like this:

-Copyright (C) 2006-2008, Uri Shkolnik, Anatoly Greenblat
+Copyright (C) 2006-2011 Siano Mobile, Inc.     (or whatever the company's legal name is)

would be fine, I think.  There's no issue with fixing the copyright statement - my
comment was that *the particular change* in the patch looked odd.

--==_Exmh_1311703682_2745P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFOLwKCcC3lWbTT17ARAm6hAKDlQE8Jtz84P4g8XegzLsftRd0waACXeXvS
q7NYr0UIH1h+8XGvcmhvIQ==
=HsW3
-----END PGP SIGNATURE-----

--==_Exmh_1311703682_2745P--

