Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1GGPjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:39:39 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56445 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1GGPjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:39:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/2] watchdog: iTCO_wdt: optionally leave watchdog enabled during restart
In-Reply-To: Your message of "Wed, 06 Jul 2011 10:09:36 MDT."
             <20110706160936.4002.1846.stgit@bhelgaas.mtv.corp.google.com>
From: Valdis.Kletnieks@vt.edu
References: <20110706160744.4002.94920.stgit@bhelgaas.mtv.corp.google.com>
            <20110706160936.4002.1846.stgit@bhelgaas.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1310053141_2519P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Jul 2011 11:39:01 -0400
Message-ID: <12164.1310053141@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E15D317.00E3,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1310053141_2519P
Content-Type: text/plain; charset=us-ascii

On Wed, 06 Jul 2011 10:09:36 MDT, Bjorn Helgaas said:

> If we reboot via BIOS, BIOS should disable the watchdog itself, so this
> shouldn't cause unintended resets, even if the user interrupts the boot.

Yes, but didn't Linus say something about BIOS code authors being
crack-addicted monkeys? :)

--==_Exmh_1310053141_2519P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOFdMVcC3lWbTT17ARAofNAJ4iGX6BrrIquwhuwIfCSezvE9JthgCg1FwB
MN45pC+cprkCX23DkcIhwso=
=MY9a
-----END PGP SIGNATURE-----

--==_Exmh_1310053141_2519P--

