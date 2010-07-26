Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0GZSkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 14:40:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46094 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0GZSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 14:40:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, fengguang.wu@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hda_intel: too quiet sound (regression)
In-Reply-To: Your message of "Mon, 26 Jul 2010 17:04:43 +0200."
             <s5htynmuvw4.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <4C4D9EDA.3060505@gmail.com>
            <s5htynmuvw4.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280169601_4182P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Jul 2010 14:40:01 -0400
Message-ID: <7512.1280169601@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C4DD681.02B1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280169601_4182P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Jul 2010 17:04:43 +0200, Takashi Iwai said:
> At Mon, 26 Jul 2010 16:42:34 +0200, Jiri Slaby wrote:
> > after I upgraded from 2.6.34-rc5-mm1 to 2.6.35-rc5-mm1 (there were other
> > issues in between them), the sound from my soundcard is very very quiet.
> > 
> > alsa-info:
> > http://www.alsa-project.org/db/?f=dcadb29a2d5d047ecf5545792ac3239dc0c8c7f0
> > 
> > Any ideas?
> 
> Looks like a regression by the amp max value check.
> The following patch should fix the problem.

> ---
> From 7ccc3eface57b6e1773fce009dac8a3da081b8b1 Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Mon, 26 Jul 2010 17:00:15 +0200
> Subject: [PATCH] ALSA: hda - Fix max amp cap calculation for IDT/STAC codecs

Confirming - I saw the same issue but didn't get a chance to track it down. This patch fixes it.
Feel free to stick a Tested-By: on it on its way upstream...

--==_Exmh_1280169601_4182P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMTdaBcC3lWbTT17ARAviKAJ9GXkE6huFJqYgdSaIZh+VTYb+t2QCfZ+Ra
W49Zu5bFkYGqxDMb7lS6CeI=
=n14r
-----END PGP SIGNATURE-----

--==_Exmh_1280169601_4182P--

