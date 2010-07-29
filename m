Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab0G2QGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:06:16 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52055 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab0G2QGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:06:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: mmotm 2010-07-27 - hda-intel audio fails to initialize
In-Reply-To: Your message of "Thu, 29 Jul 2010 07:37:56 +0200."
             <s5hhbjialvv.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <201007272226.o6RMQRBm008735@imap1.linux-foundation.org> <22094.1280355787@localhost>
            <s5hhbjialvv.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280419527_4412P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Jul 2010 12:05:27 -0400
Message-ID: <6177.1280419527@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4C51A6C9.0221,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280419527_4412P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Jul 2010 07:37:56 +0200, Takashi Iwai said:

> This was already fixed, but in the same date (July 27) as mmotm was
> created.  The commit is:
> 
>     cd7643bfb772dc7103ed6fc8dda6b233a8e14178
>     Author:     Jaroslav Kysela <perex@perex.cz>
>     ALSA: hda-intel - fix function_id rework (add missing bitmask)

Thanks, I cherry-picked that commit and my sound now works.

--==_Exmh_1280419527_4412P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMUabHcC3lWbTT17ARAnTiAJ4yHuLTy0BBPEzHBk7srLPlbbvmDACcCgm/
1D4rivpYNySBY5xGrLC4/+I=
=aWIq
-----END PGP SIGNATURE-----

--==_Exmh_1280419527_4412P--

