Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1BWUjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:39:25 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:40108 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1BWUjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:39:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next still missing patch for zcache modular Kconfig/build issue
In-Reply-To: Your message of "Wed, 23 Feb 2011 12:23:34 PST."
             <fc9a9123-cc27-4754-9222-796890553ee6@default>
From: Valdis.Kletnieks@vt.edu
References: <21508.1298491740@localhost>
            <fc9a9123-cc27-4754-9222-796890553ee6@default>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1298493554_5041P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Feb 2011 15:39:14 -0500
Message-ID: <30338.1298493554@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4D657073.005F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1298493554_5041P
Content-Type: text/plain; charset=us-ascii

On Wed, 23 Feb 2011 12:23:34 PST, Dan Magenheimer said:
> GregKH hasn't yet pulled the fix into staging-next, which feeds
> into linux-next.  See:
> 
> https://lkml.org/lkml/2011/2/18/311
> https://lkml.org/lkml/2011/2/18/342

Oh OK. Just wanted to make sure it hadn't gotten misplaced - I'm a few days
behind on reading lkml, and missed where Nitin had to respin the patch...


--==_Exmh_1298493554_5041P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNZXBycC3lWbTT17ARAj2CAJ9cNTudgdtdzBFIuZTUjYJYTSMfTACgsapB
xJy2lCxRyQzFWotiASzfC5Y=
=GRDy
-----END PGP SIGNATURE-----

--==_Exmh_1298493554_5041P--

