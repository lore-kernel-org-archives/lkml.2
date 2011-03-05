Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1CELtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 06:49:01 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:40652 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1CELs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 06:48:59 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: David Miller <davem@davemloft.net>
Cc: jslaby@suse.cz, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        netdev@vger.kernel.org, maxk@qualcomm.com
Subject: Re: tun routing is broken
In-Reply-To: Your message of "Sat, 05 Mar 2011 00:10:22 PST."
             <20110305.001022.183044112.davem@davemloft.net>
From: Valdis.Kletnieks@vt.edu
References: <20110304.010603.104076956.davem@davemloft.net> <4D70B2DC.2000005@gmail.com> <4D71EE86.6030309@suse.cz>
            <20110305.001022.183044112.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1299325683_4963P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 05 Mar 2011 06:48:03 -0500
Message-ID: <5118.1299325683@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4D7222F8.0175,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1299325683_4963P
Content-Type: text/plain; charset=us-ascii

On Sat, 05 Mar 2011 00:10:22 PST, David Miller said:
> --------------------
> ipv4: Fix __ip_dev_find() to use ifa_local instead of ifa_address.
> 
> Reported-by: Stephen Hemminger <shemminger@vyatta.com>
> Reported-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/ipv4/devinet.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 9038928..ff53860 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c

Confirming this fixes the problem I reported with IPv4 over PPP as well, thanks.


--==_Exmh_1299325683_4963P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNciLzcC3lWbTT17ARAkStAJ9DpYCYNqHJ6pZPvEjqgDwxM4RLOwCgxBgp
bEf6mJN17oDLNClP+WLBeUk=
=RDXm
-----END PGP SIGNATURE-----

--==_Exmh_1299325683_4963P--

