Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab1JPSVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 14:21:21 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42079 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab1JPSVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 14:21:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: John Hughes <john@calvaedi.com>
Cc: linux-kernel@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
        Stelian Pop <stelian@popies.net>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
In-Reply-To: Your message of "Sun, 16 Oct 2011 19:45:14 +0200."
             <4E9B182A.3020101@calvaedi.com>
From: Valdis.Kletnieks@vt.edu
References: <4E9ABBF6.3000504@calvaedi.com> <4E9ADBD3.4070404@calvaedi.com>
            <4E9B182A.3020101@calvaedi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318789218_43181P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 16 Oct 2011 14:20:18 -0400
Message-ID: <74494.1318789218@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4E9B2066.00E3,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318789218_43181P
Content-Type: text/plain; charset=us-ascii

On Sun, 16 Oct 2011 19:45:14 +0200, John Hughes said:
> >> Even though sony-laptop has code to handle the volume-up/volume-down 
> >> keys they don't work.  Pressing volume-down gets treated as 
> >> SONYPI_EVENT_PKEY_P1 and volume-up as SONYPI_EVENT_PKEY_P2.

> Here's a patch that makes the volume keys work for me.  Tested on 
> current git

> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c

Do we know if this is applicable to all Sony laptops, or only a few busticated
models?



--==_Exmh_1318789218_43181P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOmyBicC3lWbTT17ARAkT3AKCIFBGuqo3jlCsKrMNjRH1DNxo2LwCcC569
Isy5bMySfNZdzSmzeCun56Y=
=cQzb
-----END PGP SIGNATURE-----

--==_Exmh_1318789218_43181P--

