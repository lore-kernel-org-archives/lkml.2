Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab0IMEKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 00:10:47 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:60568 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0IMEKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 00:10:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] lm75: some optimisations
In-Reply-To: Your message of "Thu, 09 Sep 2010 20:11:28 +0200."
             <20100909201128.3840431b@hyperion.delvare>
From: Valdis.Kletnieks@vt.edu
References: <1284052336-25864-1-git-send-email-shubhrajyoti@ti.com> <20100909175537.GA16681@ericsson.com>
            <20100909201128.3840431b@hyperion.delvare>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284351000_6472P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Sep 2010 00:10:00 -0400
Message-ID: <30674.1284351000@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4C8DA419.00D8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1284351000_6472P
Content-Type: text/plain; charset=us-ascii

On Thu, 09 Sep 2010 20:11:28 +0200, Jean Delvare said:

> Please do NOT CC linux-kernel@vger.kernel.org. We have a mailing list
> dedicated to hardware monitoring, there's no point to add to the 200,000
> messages (literally) LKML gets every year. The more messages a list
> gets, the fewer readers it has.

Any way to represent this in the MAINTAINERS file, so that people who come
along in the fugure know that lm-sensors gets special handling in that regard?

--==_Exmh_1284351000_6472P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMjaQYcC3lWbTT17ARAuSTAJ49W0G2B41HnKXXwivndBNDZez6PgCgyUeb
X0keQAlIOb+Qdqx7ZAMEbkc=
=xarX
-----END PGP SIGNATURE-----

--==_Exmh_1284351000_6472P--

