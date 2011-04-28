Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1D1OZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:25:41 -0400
Received: from mail.wdtv.com ([66.118.69.84]:43438 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760550Ab1D1OZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:25:39 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: firewire question, kernel-2.6.38.4
Date: Thu, 28 Apr 2011 10:25:37 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.4-pclos1.pae; KDE/4.6.2; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281025.37767.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

Does kernel-2.6.38.4 have a firewire problem?

I get, when I plug the cable in and turn on my movie camera, this in the 
messages log:

Apr 27 23:20:21 coyote klogd: firewire_core: skipped bus generations, destroying all nodes
Apr 27 23:20:22 coyote klogd: firewire_core: rediscovered device fw0
Apr 27 23:20:22 coyote klogd: firewire_core: phy config: card 0, new root=ffc1, gap_count=5
Apr 27 23:20:22 coyote klogd: firewire_core: skipped bus generations, destroying all nodes
Apr 27 23:20:22 coyote klogd: firewire_core: rediscovered device fw0
Apr 27 23:20:22 coyote klogd: firewire_core: created device fw1: GUID 08004601044684e4, S100
Apr 27 23:20:25 coyote klogd: firewire_core: giving up on config rom for node id ffc0

Repeat, occasionally fw1 is used, for every time I plug the cable in.
Nothing is logged when the cable is unplugged.

Also I see in the docs that raw1394 has been removed, so how are we to 
access our movie cameras now?

Thanks for any hints.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
