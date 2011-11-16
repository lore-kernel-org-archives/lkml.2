Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab1KPA3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:29:38 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51240 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab1KPA3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:29:37 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Grant Grundler <grundler@chromium.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>
Subject: Re: [PATCH 5/5] net-next:asix: v2 update VERSION only
In-Reply-To: Your message of "Mon, 14 Nov 2011 16:52:37 PST."
             <1321318357-17723-1-git-send-email-grundler@chromium.org>
From: Valdis.Kletnieks@vt.edu
References: <1321318357-17723-1-git-send-email-grundler@chromium.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1321403368_2702P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Nov 2011 19:29:28 -0500
Message-ID: <21257.1321403368@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4EC303EA.004F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1321403368_2702P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Nov 2011 16:52:37 PST, Grant Grundler said:

> -#define DRIVER_VERSION "26-Sep-2011"
> +#define DRIVER_VERSION "08-Nov-2011"

Aren't these sort of things more than a tad silly for an in-kernel driver?

--==_Exmh_1321403368_2702P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOwwPocC3lWbTT17ARAi3iAKDlGaD5rOtykcHnfsQwTdtuq6OZgwCfUqyj
BgMK6MI5dqLwYmI6B7smRmk=
=PBdF
-----END PGP SIGNATURE-----

--==_Exmh_1321403368_2702P--

