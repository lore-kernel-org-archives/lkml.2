Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab1H3Ust (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 16:48:49 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60524 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab1H3Usp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 16:48:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, jackdachef@gmail.com,
        cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: Re: [PATCH V8 4/4] mm: frontswap: config and doc files
In-Reply-To: Your message of "Mon, 29 Aug 2011 09:49:49 PDT."
             <20110829164949.GA27238@ca-server1.us.oracle.com>
From: Valdis.Kletnieks@vt.edu
References: <20110829164949.GA27238@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314737185_2796P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Aug 2011 16:46:25 -0400
Message-ID: <19213.1314737185@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E5D4C2F.0089,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314737185_2796P
Content-Type: text/plain; charset=us-ascii

On Mon, 29 Aug 2011 09:49:49 PDT, Dan Magenheimer said:

> --- linux/mm/Kconfig	2011-08-08 08:19:26.303686905 -0600
> +++ frontswap/mm/Kconfig	2011-08-29 09:52:14.308745832 -0600
> @@ -370,3 +370,20 @@ config CLEANCACHE
>  	  in a negligible performance hit.
>  
>  	  If unsure, say Y to enable cleancache
> +
> +config FRONTSWAP
> +	bool "Enable frontswap to cache swap pages if tmem is present"
> +	depends on SWAP
> +	default n

> +
> +	  If unsure, say Y to enable frontswap.

Am I the only guy who gets irked when the "default" doesn't match the
"If unsure" suggestion?  :)  (and yes, I know we have guidelines for
what the "default" should be...)

--==_Exmh_1314737185_2796P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOXUwhcC3lWbTT17ARAidQAJ9dvc2aWheQ7QEVPHlD3c0vwHr6NQCgouUj
4nKyngyvWzkSZE2jPzCvAnc=
=Zt2l
-----END PGP SIGNATURE-----

--==_Exmh_1314737185_2796P--

