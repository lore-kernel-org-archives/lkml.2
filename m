Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0HCMap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:30:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33780 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0HCMao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:30:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeff Roberson <jroberson@jroberson.net>
Cc: linux-kernel@vger.kernel.org, aaronp@clustrix.com
Subject: Re: PCI-E Link training bug
In-Reply-To: Your message of "Tue, 03 Aug 2010 00:36:35 -1000."
             <alpine.BSF.2.00.1008030030430.1414@desktop>
From: Valdis.Kletnieks@vt.edu
References: <alpine.BSF.2.00.1008030030430.1414@desktop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280838641_4165P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Aug 2010 08:30:41 -0400
Message-ID: <60320.1280838641@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4C580BF1.03B8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280838641_4165P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Aug 2010 00:36:35 -1000, Jeff Roberson said:

> At least one intel chipset will occasionally negotiate a 4x link for an 8x 
> device in an 8x port.  It is a known errata in the 5400 mch.  

Can this get wrapped in some sort of 'if (chipset == MCH5400)'?  There's no
sense in adding an entire second of delay going around this loop 4 times when
it's a valid config on a non-5400 chipset.


--==_Exmh_1280838641_4165P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWAvxcC3lWbTT17ARAptMAKC3SpRBXroopZc12PBKq60gCiBxTwCglBFm
eJsjhG13Ys1k0lwYj8g39OQ=
=gmxO
-----END PGP SIGNATURE-----

--==_Exmh_1280838641_4165P--

