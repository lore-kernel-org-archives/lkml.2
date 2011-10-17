Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1JQHwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:52:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56028 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752644Ab1JQHws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:52:48 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19tuUB5hfdtfYwr/bbuBidnZb0oaPLFqaOkiPbjC9
	bf60oG03FNYThb
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: David Rientjes <rientjes@google.com>
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
Date: Mon, 17 Oct 2011 09:52:43 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; i686; ; )
Cc: werner <w.landgraf@ru.ru>, "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        ilw@linux.intel.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201110152119.58509.toralf.foerster@gmx.de> <alpine.DEB.2.00.1110151416360.15894@chino.kir.corp.google.com> <201110170931.59534.toralf.foerster@gmx.de>
In-Reply-To: <201110170931.59534.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110170952.43916.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Toralf Förster wrote at 09:31:58
> > What does "iwconfig" show?

And this is the state if the netwerk stops working :

wlan0     IEEE 802.11abgn  ESSID:"IBM"  
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:21:55:AC:8B:80   
          Bit Rate=54 Mb/s   Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=45/70  Signal level=-65 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:77   Missed beacon:0


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
