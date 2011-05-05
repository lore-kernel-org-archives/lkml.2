Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1EEVYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:24:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43824 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1EEVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:24:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reboot: disable usermodehelper to prevent fs access
In-Reply-To: Your message of "Thu, 05 May 2011 13:32:05 +0200."
             <1304595126.1284.3.camel@zag>
From: Valdis.Kletnieks@vt.edu
References: <1304595126.1284.3.camel@zag>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304630665_5038P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 May 2011 17:24:25 -0400
Message-ID: <39558.1304630665@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DC3158A.0092,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304630665_5038P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 May 2011 13:32:05 +0200, Kay Sievers said:

> In case CONFIG_UEVENT_HELPER_PATH is not set to "", which it
> should be on every system

If it indeed should be that on every system, shouldn't it be listed
in feature-removal-schedule.txt?

Does anybody have a running list of "Stuff we set by default at one time, but
no longer recommend"?  I discovered that on my laptop, I have this sucker set
to /sbin/hotplug still (which explains why I get "filesystem busy" issues at
shutdown.  Just like the TCP_BIC issue yesterday, it's something that got set
aeons ago and 'make oldconfig' has been propagating.

But to clean things up, I'd have to know what stuff needed cleaning....



--==_Exmh_1304630665_5038P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwxWJcC3lWbTT17ARAnp6AKC402yaJplcEgxq6WfFBAuHnOwqvQCgzIGr
HA/rSMk7PY03nsRsf+dAWTU=
=TYAo
-----END PGP SIGNATURE-----

--==_Exmh_1304630665_5038P--

