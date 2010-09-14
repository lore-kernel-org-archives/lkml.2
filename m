Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0INRfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:35:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36130 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0INRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:35:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Maurus Cuelenaere <mcuelenaere@gmail.com>
Cc: =?UTF-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Fabien Chouteau <fabien.chouteau@barco.com>,
        david Brownell <dbrownell@users.sourceforge.net>,
        Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
        LKML <linux-kernel@vger.kernel.org>, MeeGo <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Arjan <arjan@linux.intel.com>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>
Subject: Re: [PATCH] USB device driver of Topcliff PCH
In-Reply-To: Your message of "Tue, 14 Sep 2010 14:50:45 +0200."
             <4C8F6FA5.7020201@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <4C85EE6F.6000706@dsn.okisemi.com> <AANLkTikSb-16eACaR16Uh2c7K=2yT3e+Vna=Z2Tt-x=6@mail.gmail.com> <000a01cb52fb$78fc2310$66f8800a@maildom.okisemi.com> <4C8DFC56.8020006@gmail.com> <op.viyyabj27p4s8u@pikus>
            <4C8F6FA5.7020201@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284485595_4681P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Sep 2010 13:33:15 -0400
Message-ID: <15771.1284485595@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4C8FB1DD.015F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284485595_4681P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Sep 2010 14:50:45 +0200, Maurus Cuelenaere said:

> Ah, well IMHO it's better not to spam LKML with subsystem-related stuff..

On the flip side, posting to LKML as well means that it's a bit harder for a
patch series to go totally down a rathole, because people outside the subsystem
then have a chance to look at the code and point out where it's going in the
wrong direction. My last code comment was regarding hardware I didn't have, and
happened because I asked myself "What would happen if that code tried to run on
my laptop?".  Similarly, we see lots of stuff posted that looks good to those
of us on 1-4 core systems, only to have somebody from SGI point out that it
will add 45 hours to boot time on one of their big boxes.  And so on.


--==_Exmh_1284485595_4681P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMj7HbcC3lWbTT17ARAkNfAJ0Vu5jNkQxpBBlpXqsFO7VvhIL7GQCfdBLN
s+VeuxSI/F0OZNMSqSI+Q9k=
=Tnlc
-----END PGP SIGNATURE-----

--==_Exmh_1284485595_4681P--

