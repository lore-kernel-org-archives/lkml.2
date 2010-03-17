Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab0CQUaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 16:30:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57761 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0CQUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:30:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Holger Schurig <holgerschurig@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Weird wireless/wpa_supplicant screw-up.
In-Reply-To: Your message of "Wed, 17 Mar 2010 10:03:54 BST."
             <201003171003.54295.holgerschurig@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <7197.1268086939@localhost> <1268796150.7068.6.camel@jlt3.sipsolutions.net> <27228.1268814093@localhost>
            <201003171003.54295.holgerschurig@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268857787_3820P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Mar 2010 16:29:47 -0400
Message-ID: <24712.1268857787@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4BA13BBB.017F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268857787_3820P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <24706.1268857787.1@localhost>

On Wed, 17 Mar 2010 10:03:54 BST, Holger Schurig said:

> And in this case, you can use "wpa_cli status" and well see all the details, 
> no matter if you use WPA, WPA2, WEXT or some of the 802.11x derivates:

Wow. Is *that* where they hid it?  

In any case, that does fit the bill, even if it was well-hidden:

# wpa_cli status
Selected interface 'wlan0'
bssid=00:0f:f7:14:2a:91
ssid=VT-Wireless
id=0
pairwise_cipher=CCMP
group_cipher=TKIP
key_mgmt=WPA2/IEEE 802.1X/EAP
wpa_state=COMPLETED
ip_address=172.31.143.252
Supplicant PAE state=AUTHENTICATED
suppPortStatus=Authorized
EAP state=SUCCESS
selectedMethod=13 (EAP-TLS)
EAP TLS cipher=DHE-RSA-AES256-SHA




--==_Exmh_1268857787_3820P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLoTu7cC3lWbTT17ARAsU4AJ4kYt/FIG1AtC6caAr0cqCvNsWHnwCg4ofn
MQe9ryCVr8h3YoqstRhDC9M=
=AfXw
-----END PGP SIGNATURE-----

--==_Exmh_1268857787_3820P--

