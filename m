Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab2AFUmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:42:39 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47260 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166Ab2AFUmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:42:38 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
In-Reply-To: Your message of "Thu, 05 Jan 2012 14:04:30 GMT."
             <4F05BBFE020000780006A983@nat28.tlf.novell.com>
From: Valdis.Kletnieks@vt.edu
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1325882419_3358P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 06 Jan 2012 15:40:19 -0500
Message-ID: <73464.1325882419@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4F075C39.0012,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1325882419_3358P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 Jan 2012 14:04:30 GMT, Jan Beulich said:
> Forever these two functions have been limited to deal with at most 4G
> at a time. While I cannot point out an in-tree user that would require
> larger sizes, it is now the second time that within our Xen kernel we got
> bitten by that limitation.

Wow.  Second time?  What the heck is the Xen kernel *doing* that it's
trying to do over 4G in a single memset/memcpy?

--==_Exmh_1325882419_3358P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFPB1wzcC3lWbTT17ARAm+UAJ9GQJ0ceZku5tRPaVvpdzm868jlAACg0bRm
qSN5cBkWQwEi8Q907Byhn+Q=
=U3eQ
-----END PGP SIGNATURE-----

--==_Exmh_1325882419_3358P--

