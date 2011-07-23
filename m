Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1GWT1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 15:27:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41813 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753325Ab1GWT1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 15:27:39 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18HeZNH8uEHCQETI6Q2EptA15Yurn6Q/ewXCGXmax
	o/wixko8Sho2e1
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400
Date: Sat, 23 Jul 2011 21:27:34 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39.3; KDE/4.6.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107232127.34255.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last lines are :
...
2011-07-23T17:57:21.000+02:00 n22 pppd[2324]: Exit.
2011-07-23T17:57:22.896+02:00 n22 kernel: PM: Syncing filesystems ... done.
2011-07-23T17:57:22.896+02:00 n22 kernel: PM: Preparing system for mem sleep
2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: Deleting interface #3 ppp0, 
92.224.126.27#123, interface stats: received=269, sent=269, dropped=0, 
active_time=13305 secs
2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: 78.47.24.68 interface 
92.224.126.27 -> (none)
2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: 213.198.55.2 interface 
92.224.126.27 -> (none)
2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: 213.133.112.102 interface 
92.224.126.27 -> (none)
2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: 141.40.103.103 interface 
92.224.126.27 -> (none)
2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: peers refreshed

magic SysRq  keys works .

Anybody else experienced sth similar ?

2.6.39.3 works flawlessly

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
