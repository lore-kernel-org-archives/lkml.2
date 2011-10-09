Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1JIRnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 13:43:50 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33224 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1JIRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 13:43:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] regmap: Allow caches for devices with no defaults
In-Reply-To: Your message of "Sun, 09 Oct 2011 14:44:36 BST."
             <1318167876-17801-2-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Valdis.Kletnieks@vt.edu
References: <1318167876-17801-1-git-send-email-broonie@opensource.wolfsonmicro.com>
            <1318167876-17801-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318182222_103142P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 09 Oct 2011 13:43:42 -0400
Message-ID: <109263.1318182222@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E91DD52.002E,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318182222_103142P
Content-Type: text/plain; charset=us-ascii

On Sun, 09 Oct 2011 14:44:36 BST, Mark Brown said:
> We only really need the defaults in order to cut down the number of
> registers we sync and to satisfy reads while the device is powered off

So let me get this straight - we cache the values so that if there's a read,
we can return our best guess as to what the device would return if it was
in fact powered on, instead of notifying the caller that the device is off?

I think I just sprained my brain trying to parse the logic there :)

--==_Exmh_1318182222_103142P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOkd1OcC3lWbTT17ARAsq9AJ9z6NAfPQU/AJlkrblIH1e4YS+a2gCg2a3f
kN35nSENMCcMOL6lZ3zhMYQ=
=kBsk
-----END PGP SIGNATURE-----

--==_Exmh_1318182222_103142P--

