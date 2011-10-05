Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934939Ab1JETUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:20:08 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36922 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab1JETUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:20:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Thomas Tuttle <ttuttle@chromium.org>
Cc: linux-kernel@vger.kernel.org, Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] ramoops: scripts/ramoops.c for extracting oopses
In-Reply-To: Your message of "Wed, 05 Oct 2011 14:25:03 EDT."
             <20111005182503.GA6142@google.com>
From: Valdis.Kletnieks@vt.edu
References: <20111005182503.GA6142@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317842403_2599P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Oct 2011 15:20:03 -0400
Message-ID: <19809.1317842403@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E8CADE4.014D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317842403_2599P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Oct 2011 14:25:03 EDT, Thomas Tuttle said:
> Add a C program to extract oopses stored by ramoops.  Running with no
> arguments will list all of the records; running with an argument number
> will retrieve the oops from that record, if it is valid.

> + * ramoops: Extract ramoops images from /dev/mem.

How does this play with CONFIG_STRICT_DEVMEM?

--==_Exmh_1317842403_2599P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjK3jcC3lWbTT17ARArm3AJ9N6z2Hn/q52i4IIM3MpD13GOmRXgCeM1uH
H8lup9uzA65bTPJx2qJX7ec=
=Vqc9
-----END PGP SIGNATURE-----

--==_Exmh_1317842403_2599P--

