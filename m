Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab0HEP0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:26:05 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:42893 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933467Ab0HEP0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:26:01 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 11:26:00 EDT
Message-ID: <4C5AD674.30908@example.com>
Date: Thu, 05 Aug 2010 17:19:16 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: The horror is over, but I deleted and forgot some lines - please
 help
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15453257698511319320
X-Ovh-Remote: 83.24.108.219 (doa219.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I git-synchronized linux kernel source but it failed to build. I 
discovered that the problem is in sound/pci/hda/hda_codec.c . There was 
some git specific line of text, so I just deleted it and some other two 
lines. It failed again because one of the lines that I just deleted 
contained trailing { brace, closing for statement as far as I remember.

Can somebody remind me what had I deleted at first? And how to spot such 
situations in the future? I thought that I could write a script to 
search and i.e. grep *.c files in the source to catch such coliding 
places. But I don't know what should I search.

Reagrds,

Piotr Hosowicz

PS: With working sound ;-)

-- 
Na przyjêciu ch³opak pyta blondynkê:
- Czy mogê ciê prosiæ do walca?
- Zg³upia³e¶? To ju¿ nie mia³e¶ czym przyjechaæ?
NP: Peter Green Splinter Group - Turn Your Love Away
NB: 2.6.35-20100805-1436+
