Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab1IWS6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:58:44 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46004 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1IWS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:58:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        chris.mason@oracle.com
Subject: Re: [PATCH] btrfs/extent_map.c: quiet sparse noise
In-Reply-To: Your message of "Thu, 22 Sep 2011 18:45:56 PDT."
             <201109221845.56204.hartleys@visionengravers.com>
From: Valdis.Kletnieks@vt.edu
References: <201109221845.56204.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316804317_4577P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Sep 2011 14:58:37 -0400
Message-ID: <25617.1316804317@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4E7CD6DF.011C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316804317_4577P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Sep 2011 18:45:56 PDT, H Hartley Sweeten said:
> Quiet the sparse noise:
> 
> warning: symbol '__lookup_extent_mapping' was not declared. Should it be static?

Patch itself is correct, changelog is bad.  You're not quieting sparse noise,
you're making a declaration static because it doesn't need external visibility.

--==_Exmh_1316804317_4577P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfNbdcC3lWbTT17ARAvynAKCqgZ+D+5TdpgvcXB8jfkcAvQkUyACffzq4
4GLdG6v+VgGVHHKUQiSUcno=
=Vijq
-----END PGP SIGNATURE-----

--==_Exmh_1316804317_4577P--

