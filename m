Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1KQDTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 22:19:11 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51534 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1KQDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 22:19:09 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Grant Grundler <grundler@chromium.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>
Subject: Re: [PATCH 5/5] net-next:asix: v2 update VERSION only
In-Reply-To: Your message of "Tue, 15 Nov 2011 17:37:47 PST."
             <CANEJEGtnUS5B1ggdoPn8gcCbFm==dfgHCgXVgcgpuooFUAowJA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1321318357-17723-1-git-send-email-grundler@chromium.org> <21257.1321403368@turing-police.cc.vt.edu>
            <CANEJEGtnUS5B1ggdoPn8gcCbFm==dfgHCgXVgcgpuooFUAowJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1321499937_2949P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Nov 2011 22:18:57 -0500
Message-ID: <5923.1321499937@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4EC47D26.0031,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1321499937_2949P
Content-Type: text/plain; charset=us-ascii

On Tue, 15 Nov 2011 17:37:47 PST, Grant Grundler said:

> Upstream drivers are routinely back ported to distro releases. Version
> is the primary means for a vendor (like ASIX) to determine what was
> back ported. Distro maintainers and 1st tier support organizations
> also need to track versions and "ethtool -i" is the canonical way to
> look this up on a running system.

Oh, OK.  I figured the distro would know what they backported based on the
kernel version they generated - I forgot that sometimes users will bypass the
distro and go to the upstream vendor, and you may not know what their distro
had done...


--==_Exmh_1321499937_2949P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOxH0hcC3lWbTT17ARAou4AKCq7QNRGeE3On+xkRFF8cTaxLPqbQCdEUlZ
9JNfZMRCVtSkj2nwN9HVJUQ=
=cMmn
-----END PGP SIGNATURE-----

--==_Exmh_1321499937_2949P--

