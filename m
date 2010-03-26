Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab0CZCSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:18:39 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45176 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0CZCSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:18:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gary Yang <garyyang6@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to insert splint info Makefile? Any idea?
In-Reply-To: Your message of "Thu, 25 Mar 2010 18:30:36 PDT."
             <16733.35890.qm@web37904.mail.mud.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <16733.35890.qm@web37904.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1269569908_3900P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Mar 2010 22:18:28 -0400
Message-ID: <11505.1269569908@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=50/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=bulk(0),
	refid=str=0001.0A020203.4BABC5FB.0294,ss=3,sh,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1269569908_3900P
Content-Type: text/plain; charset=us-ascii

On Thu, 25 Mar 2010 18:30:36 PDT, Gary Yang said:
> I am working on linux-2.6.25. I would like to use splint. At one of the
> source directory, I typed "splint *.c". I got "Cannot find include file",
> "Cannot continue". I understand that I need to run splint inside the Makefile
> so that it will find the correct include files. However, how to insert splint
> info Makefile? Any idea?

Look at how 'sparse' support is done.

--==_Exmh_1269569908_3900P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLrBl0cC3lWbTT17ARAu/KAKCi3k++VUd3+iULJBOdupcUwzmrfACg5Cnf
+iGSDn0ySXayY8lZHfUlhV0=
=xHG1
-----END PGP SIGNATURE-----

--==_Exmh_1269569908_3900P--

