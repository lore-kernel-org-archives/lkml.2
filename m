Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab0LUPKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 10:10:39 -0500
Received: from 64.mail-out.ovh.net ([91.121.185.65]:50040 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751876Ab0LUPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 10:10:38 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Dec 2010 10:10:37 EST
Message-ID: <4D10C1D9.7040604@example.com>
Date: Tue, 21 Dec 2010 16:03:53 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101211 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: rc6-git6 patch spoils drivers/block/cciss.c
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13968758669639381272
X-Ovh-Remote: 178.42.63.136 (afml136.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There is an error in abovementioned file, there should be a semicolon 
after continue statement in line 2838. I corrected it by hand and it 
seems to be happily building now. It seems that this error appeared for 
a moment on main Linux tree, because I had the same error a moment ago 
when tryibng to build from GIT tree.

Regards,

Piotr Hosowicz

-- 
W korytarzach kremlowskich Bre¿niew spotyka Sus³owa. Sus³ow pyta:
- Leonid, wiesz, ¿e jeden but masz ¿ó³ty, a drugi czarny?
- Wiem, Misza, chcia³em nawet zmieniæ, ale w domu mam to samo,
   jeden ¿ó³ty i jeden czarny.
NP: Patrick O'Hearn - Forsaken Beauty
NB: 2.6.37-rc6-git5
