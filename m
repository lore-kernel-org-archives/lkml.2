Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab1FWOTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:19:16 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49408 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab1FWOTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:19:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/3] mfd: Add Makefile and Kconfig Entries for tps65911 comparator
In-Reply-To: Your message of "Thu, 23 Jun 2011 10:15:51 +0800."
             <1308795351.15248.2.camel@phoenix>
From: Valdis.Kletnieks@vt.edu
References: <1308795351.15248.2.camel@phoenix>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1308838745_4530P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Jun 2011 10:19:05 -0400
Message-ID: <43010.1308838745@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A010207.4E034B5D.004C,ss=1,fgs=0,
	ip=24.127.43.116,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1308838745_4530P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Jun 2011 10:15:51 +0800, Axel Lin said:
> Base on Mark's comment [1], I make the Kconfig entry invisible to users.

> +config TPS65911_COMPARATOR
> +	tristate
> +

This can't possibly be right by itself- how would it ever get enabled, without
a SELECT pointing at it or a user selecting it?

Is there a follow-on patch that adds a user?



--==_Exmh_1308838745_4530P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOA0tZcC3lWbTT17ARAoesAJ9FkR4F855yTsqyYvydxuDy7cmpewCgoaEZ
YyLwKUz5Ge4+lDF9evuCRJM=
=LA29
-----END PGP SIGNATURE-----

--==_Exmh_1308838745_4530P--

