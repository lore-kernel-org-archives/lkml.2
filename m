Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1DIUZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 16:25:32 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57899 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab1DIUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:25:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] char: istallion: fix arbitrary kernel memory reads/writes
In-Reply-To: Your message of "Sat, 09 Apr 2011 15:26:59 +0200."
             <4DA05EA3.5080008@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1302352882-20802-1-git-send-email-segoon@openwall.com>
            <4DA05EA3.5080008@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302380698_4802P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 09 Apr 2011 16:24:58 -0400
Message-ID: <107257.1302380698@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4DA0C09E.006F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302380698_4802P
Content-Type: text/plain; charset=us-ascii

On Sat, 09 Apr 2011 15:26:59 +0200, Jiri Slaby said:
> On 04/09/2011 02:41 PM, Vasiliy Kulikov wrote:
> > stli_brdstats is defined as global variable.  After de-BKL-ization in
> > the patch b4eda9cb48eac1b7 an access to the variable is not serialized
> > anymore.  This leads to the TOCTOU in stli_getbrdstats():
> 
> Don't use such a weird and uncommon abbreviations.

Time Of Check [to] Time Of Use.  Hardly uncommon, especially in the security
community. Googling for 'TOCTOU' and 'TOCTTOU' gets about 60K hits combined.


--==_Exmh_1302380698_4802P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNoMCacC3lWbTT17ARAiTvAKDxl6hfOcuPwiss3QQRWgpRGzaMYgCg/Xxu
Fry7V/9flPeNB5KqiJCAuR8=
=QRCB
-----END PGP SIGNATURE-----

--==_Exmh_1302380698_4802P--

