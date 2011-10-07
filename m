Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab1JGSdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:33:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47438 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab1JGSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:33:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Josh Boyer <jwboyer@gmail.com>
Cc: Frank Mehnert <frank.mehnert@oracle.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
Subject: Re: RFC: virtualbox tainting.
In-Reply-To: Your message of "Fri, 07 Oct 2011 14:10:18 EDT."
             <CA+5PVA7iFDm17faPowUNNh3BnYMxUGPXRzbu9vkbVWW1m9Hvfg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20111006190526.GA13883@redhat.com> <201110071640.53827.frank.mehnert@oracle.com> <CA+5PVA4v0D_ppnjN_k_6AcDEfH_U0Nn9WLfb3J84JGBGBOFBsg@mail.gmail.com> <14824.1318004546@turing-police.cc.vt.edu>
            <CA+5PVA7iFDm17faPowUNNh3BnYMxUGPXRzbu9vkbVWW1m9Hvfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318012410_9306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Oct 2011 14:33:30 -0400
Message-ID: <19981.1318012410@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E8F45FE.0057,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318012410_9306P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Oct 2011 14:10:18 EDT, Josh Boyer said:

> (Somehow the distributions get the brunt of the blame from the users,
> but I'm not going to go down that path.  I'm trying to be productive.)

The problem is that stuff like kerneloops and the RedHat 'abrtd' daemon tend to
forward to the distro, not the third-party vendor.  But I'm suspecting that if
Dave Jones and Frank have a nice discussion and work something out, we'll *all*
be better off. I'd not be surprised if Dave has bug reports for stuff Frank
hasn't seen, because the reports go to RedHat and Oracle never got a copy before.


--==_Exmh_1318012410_9306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOj0X6cC3lWbTT17ARAt6eAJ4sT8o/NINp81FB6Xg6VRxF0BjLsQCgve5e
zLCPyQb/c0J161JJpFFA6qo=
=Hxl/
-----END PGP SIGNATURE-----

--==_Exmh_1318012410_9306P--

