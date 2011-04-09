Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1DITaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:30:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56361 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab1DITa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:30:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: pavan_savoy@ti.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, pavan_savoy@sify.com
Subject: Re: [PATCH 2/3] drivers:misc:ti-st: remove rfkill dependency
In-Reply-To: Your message of "Fri, 08 Apr 2011 04:57:43 CDT."
             <1302256664-23688-3-git-send-email-pavan_savoy@ti.com>
From: Valdis.Kletnieks@vt.edu
References: <1302256664-23688-1-git-send-email-pavan_savoy@ti.com> <1302256664-23688-2-git-send-email-pavan_savoy@ti.com>
            <1302256664-23688-3-git-send-email-pavan_savoy@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302377420_4802P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 09 Apr 2011 15:30:20 -0400
Message-ID: <105494.1302377420@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DA0B3D0.003C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302377420_4802P
Content-Type: text/plain; charset=us-ascii

On Fri, 08 Apr 2011 04:57:43 CDT, pavan_savoy@ti.com said:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> rfkill is no longer used by Texas Instruments shared transport driver to
> communicate with user-space.

Color me confoozled.  What's it using instead to provide the rfkill functionality?

(I'm OK on the actual patch, just the changelog is a tad ambiguous for those
of us tuning in late...)

--==_Exmh_1302377420_4802P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNoLPMcC3lWbTT17ARApKrAJ910yAmUiy6DVP9ZUamVgXyKR8+gQCfYPrT
zNBKKI+0dJxhBl38ki/Iaz0=
=Vnb0
-----END PGP SIGNATURE-----

--==_Exmh_1302377420_4802P--

