Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0CQJCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:02:50 -0400
Received: from mx51.mymxserver.com ([85.199.173.110]:19295 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0CQJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:02:48 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: Weird wireless/wpa_supplicant screw-up.
Date: Wed, 17 Mar 2010 10:03:54 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.33-rc8; KDE/4.4.1; i686; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
References: <7197.1268086939@localhost> <1268796150.7068.6.camel@jlt3.sipsolutions.net> <27228.1268814093@localhost>
In-Reply-To: <27228.1268814093@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003171003.54295.holgerschurig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is a combination of things - (a) iwlist and iwconfig report no
> crypto and (b) there doesn't seem to be any *other* way for userspace to
> find out that in fact you have an encrypted WPA2 connection.

That's not true.


I'm using cfg80211 with wpa_supplicant (even when I only use WEP, despite the 
name of the wpa_supplicant application!).

And in this case, you can use "wpa_cli status" and well see all the details, 
no matter if you use WPA, WPA2, WEXT or some of the 802.11x derivates:

# wpa_cli status
Selected interface 'wlan0'
bssid=00:xx:xx:xx:xx:xx
ssid=MUMBLEFUTZ
id=0
mode=station
pairwise_cipher=WEP-40
group_cipher=WEP-40
key_mgmt=NONE
wpa_state=COMPLETED
ip_address=172.16.xxx.xx

-- 
http://www.holgerschurig.de
