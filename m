Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1GEWZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:25:44 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39972 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1GEWZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:25:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Add watchdog driver for Intel E6XX
In-Reply-To: Your message of "Mon, 04 Jul 2011 15:29:08 +0200."
             <1309786148-5138-2-git-send-email-alexander.stein@systec-electronic.com>
From: Valdis.Kletnieks@vt.edu
References: <20110701110002.GA9326@infomag.iguana.be>
            <1309786148-5138-2-git-send-email-alexander.stein@systec-electronic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1309904673_18528P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jul 2011 18:24:33 -0400
Message-ID: <61870.1309904673@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E138F24.0011,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1309904673_18528P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Jul 2011 15:29:08 +0200, Alexander Stein said:
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

> +config IE6XX_WATCHDOG
> +	tristate "Intel E6XX watchdog"
> +	depends on WATCHDOG && PCI && X86
> +	select MFD_CORE
> +	select LPC_SCH
> +	---help---
> +	  Hardware driver for the watchdog timer built into the Intel
> +	  E6XX (TunnelCreek) processor.

That addresses my comment on the patchset, feel free to stick an Acked-By: or
whatever is called for in there...


--==_Exmh_1309904673_18528P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOE48hcC3lWbTT17ARAum+AJ93gakw8kROiW4d06eXaVOut0ql6gCZAYgx
ANj8C/UJXc3JQIRIdHQuCDM=
=7vfM
-----END PGP SIGNATURE-----

--==_Exmh_1309904673_18528P--

