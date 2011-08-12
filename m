Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1HLQm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:42:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36172 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1HLQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:42:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Tonda <as@strmilov.cz>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: TCP port firewall controlled by UDP packets
In-Reply-To: Your message of "Fri, 12 Aug 2011 01:56:09 +0200."
             <1313106969-18733-1-git-send-email-as@strmilov.cz>
From: Valdis.Kletnieks@vt.edu
References: <1313106969-18733-1-git-send-email-as@strmilov.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313167234_2634P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Aug 2011 12:40:34 -0400
Message-ID: <6556.1313167234@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E455783.0148,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1313167234_2634P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Aug 2011 01:56:09 +0200, Tonda said:
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -624,3 +624,7 @@
>  	  on the Internet.
>  
>  	  If unsure, say N.
> +
> +config TCPFIREWALL
> +	tristate "TCP Firewall controlled by UDP queries"
> +	depends on m

I don't suppose it would be asking too much to support UPNP here, would it?
https://secure.wikimedia.org/wikipedia/en/wiki/Internet_Gateway_Device_Protocol

(If this in fact *does* do the UPNP thing, then this *really* needs better docs).


--==_Exmh_1313167234_2634P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFORVeCcC3lWbTT17ARArKFAKCYJ+Eq1gVGp+7tcrQFTpz6cF1WrwCg+4/U
BXGIxPr7tXpJbXcx5TZF6Kk=
=6ULu
-----END PGP SIGNATURE-----

--==_Exmh_1313167234_2634P--

