Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0CQIWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:22:01 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42274 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab0CQIV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:21:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Weird wireless/wpa_supplicant screw-up.
In-Reply-To: Your message of "Tue, 16 Mar 2010 20:22:30 PDT."
             <1268796150.7068.6.camel@jlt3.sipsolutions.net>
From: Valdis.Kletnieks@vt.edu
References: <7197.1268086939@localhost> <1268392481.4828.7.camel@jlt3.sipsolutions.net> <5220.1268430568@localhost> <1268449749.4880.2.camel@jlt3.sipsolutions.net> <12262.1268795213@localhost>
            <1268796150.7068.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268814093_4069P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Mar 2010 04:21:33 -0400
Message-ID: <27228.1268814093@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4BA0910E.0060,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268814093_4069P
Content-Type: text/plain; charset=us-ascii

On Tue, 16 Mar 2010 20:22:30 PDT, Johannes Berg said:
> On Tue, 2010-03-16 at 23:06 -0400, Valdis.Kletnieks@vt.edu wrote:

> > If a TX key has been set anyplace, what allows me
> > to verify that it was in fact set?
> 
> Nothing. Blame it on wext and on the fact that nobody cares.

Pretty fucking fundemental thing to not care about, being able to tell whether
or not your connection is in fact encrypted or not. But I guess you expect
users to be all-knowing and magically know that even though iwconfig says
'Encryption key: off' that in fact their connection is encrypted (unless of
course it's off because it's not encrypted), and how to troubleshoot the
difference between "not encrypted" and "lying about not being encrypted" when
the utilities in wireless-tools provide the same output in both cases.

Unfortunately, I'm a stupid idiot, and when I'm trying to get wpa_supplicant
working and hitting various unrelated certificate issues, resolve those,
finally get wpa_supplicant to say it connected, but then I type 'iwconfig'
and it *still* says "Encryption key: off", I'm unable to make the leap of
logic and say "AHA! It's encrypted now", and I start trying to find what I
still have to fix so it will say it's encrypted.

Sorry for bothering you and wasting your time.

> problem is, if there is one. If your actual problem is just that iwlist
> reports what you think is wrong information (which is just incomplete,
> it doesn't show the PTK) then that's nothing I actually care about
> fixing.

The problem is a combination of things - (a) iwlist and iwconfig report no
crypto and (b) there doesn't seem to be any *other* way for userspace to find
out that in fact you have an encrypted WPA2 connection.


--==_Exmh_1268814093_4069P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLoJENcC3lWbTT17ARAsxYAKDjRLnZWhj1c2zZV1D/gE1H40kfaQCgm00D
6O3y8QKZrwEJkoSbT+uKXiY=
=UzQ0
-----END PGP SIGNATURE-----

--==_Exmh_1268814093_4069P--

