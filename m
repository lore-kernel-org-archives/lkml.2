Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1IWWXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:23:44 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55906 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1IWWXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:23:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Tero Kristo <t-kristo@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 00/18] omap PRCM chain handler
In-Reply-To: Your message of "Fri, 23 Sep 2011 15:46:08 +0300."
             <1316781986-30642-1-git-send-email-t-kristo@ti.com>
From: Valdis.Kletnieks@vt.edu
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316816580_33036P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Sep 2011 18:23:00 -0400
Message-ID: <35343.1316816580@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4E7D06CA.00DE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316816580_33036P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 Sep 2011 15:46:08 +0300, Tero Kristo said:
> Following set contains the version 9 of this work. This patch set contains
> a number of patches tagged as 'TEMP', they are only meant for testing
> purposes and to provide proof of concept. Most of the 'TEMP' patches are
> related to UART runtime handling and they will be replaced by work done
> by Govindraj Raja.

What do we do with these TEMP patches if the UART patches don't make the same
merge window, or have other issues?  I'm always leery of "will be replaced"
code, because I've seen too many times when it *didn't* get replaced.

(I really don't care what the 'Plan B' is, as long as we have one...)



--==_Exmh_1316816580_33036P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfQbEcC3lWbTT17ARAoJHAKDKTuOc5fuoHVqy9MaQZ5Sfgju2CgCcC6VP
esd5WI1469tFcgwhYBmz+50=
=zTeo
-----END PGP SIGNATURE-----

--==_Exmh_1316816580_33036P--

