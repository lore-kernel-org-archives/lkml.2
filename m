Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab1HLT04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:26:56 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52271 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1HLT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:26:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Antonin Steinhauser <as@strmilov.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: TCP port firewall controlled by UDP packets
In-Reply-To: Your message of "Fri, 12 Aug 2011 17:35:07 +0200."
             <4E45482B.7080207@strmilov.cz>
From: Valdis.Kletnieks@vt.edu
References: <1313106969-18733-1-git-send-email-as@strmilov.cz> <20110811171317.271be88b.rdunlap@xenotime.net>
            <4E45482B.7080207@strmilov.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313177110_2634P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Aug 2011 15:25:10 -0400
Message-ID: <14788.1313177110@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E457E18.00DF,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1313177110_2634P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Aug 2011 17:35:07 +0200, Antonin Steinhauser said:
> Dne 12.8.2011 02:13, Randy Dunlap napsal(a):
> > On Fri, 12 Aug 2011 01:56:09 +0200 Tonda wrote:
> >> +config TCPFIREWALL
> >> +	tristate "TCP Firewall controlled by UDP queries"
> >> +	depends on m
> >>
> > Why buildable only as a loadable module?
> >
> >
> Because it needs parameter - address of inet_protos table from
> /boot/System_map

That's probably a very good indication that you're doing it the wrong way, and
need to redesign what you're doing....


--==_Exmh_1313177110_2634P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFORX4WcC3lWbTT17ARAuhFAKCDyXIT+ig4eR06XyzBXCt48dZboACePLl7
TWBfv0/q2LLg7EOYbPZ51AY=
=+t5Z
-----END PGP SIGNATURE-----

--==_Exmh_1313177110_2634P--

