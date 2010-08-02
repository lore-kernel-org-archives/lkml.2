Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0HBM4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:56:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43010 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HBM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:56:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: hp fk <fkhp101@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a Great Idea - include Kademlia networking protocol in kernel
In-Reply-To: Your message of "Mon, 02 Aug 2010 20:24:38 +0800."
             <AANLkTik7powjUaJ51bA_bgPVb03U-RVZay3NffHBYLzx@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTik7powjUaJ51bA_bgPVb03U-RVZay3NffHBYLzx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280753770_76572P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Aug 2010 08:56:10 -0400
Message-ID: <215375.1280753770@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4C56C06B.0201,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280753770_76572P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Aug 2010 20:24:38 +0800, hp fk said:
> Kademlia protocol is widely used by many p2p applications, if kernel
> support the Kademlia protocol and its p2p network infrastracture. it
> will be easier to bring us into a new stage of network with much more
> freedom and equality

1) You failed to explain what kernel support, if any, would be needed for this
protocol.  What does Kademlia do that the current kernel can't handle already?
(Hint - if it runs on a Windows system without patching the Windows kernel, it
almost certainly doesn't need extensive patches for Linux either).

2) You forgot to cc: netdev@vger.kernel.org, which is where all the networking
people hang out.


--==_Exmh_1280753770_76572P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMVsBqcC3lWbTT17ARAilVAKDCM2p5BjgcPJVsLBvWB1/hZHEyFwCfXF9j
yJAtnU5cRuAEj9QxKr/NTx8=
=jSZC
-----END PGP SIGNATURE-----

--==_Exmh_1280753770_76572P--

