Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1GWTru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 15:47:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45061 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab1GWTrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 15:47:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: Re: suspend/resume problems w/ kernel 3.0 and a *docked* ThinkPad T400
Date: Sat, 23 Jul 2011 21:48:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <201107232127.34255.toralf.foerster@gmx.de>
In-Reply-To: <201107232127.34255.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107232148.44702.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 23, 2011, Toralf Förster wrote:
> The last lines are :
> ...
> 2011-07-23T17:57:21.000+02:00 n22 pppd[2324]: Exit.
> 2011-07-23T17:57:22.896+02:00 n22 kernel: PM: Syncing filesystems ... done.
> 2011-07-23T17:57:22.896+02:00 n22 kernel: PM: Preparing system for mem sleep
> 2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: Deleting interface #3 ppp0, 
> 92.224.126.27#123, interface stats: received=269, sent=269, dropped=0, 
> active_time=13305 secs
> 2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: 78.47.24.68 interface 
> 92.224.126.27 -> (none)
> 2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: 213.198.55.2 interface 
> 92.224.126.27 -> (none)
> 2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: 213.133.112.102 interface 
> 92.224.126.27 -> (none)
> 2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: 141.40.103.103 interface 
> 92.224.126.27 -> (none)
> 2011-07-23T17:57:23.000+02:00 n22 ntpd[9544]: peers refreshed
> 
> magic SysRq  keys works .
> 
> Anybody else experienced sth similar ?

Not that I know of.

I wonder what happens if the machine is undocked?

Rafael
