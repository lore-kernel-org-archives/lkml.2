Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0LRQCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 11:02:55 -0500
Received: from 29.mail-out.ovh.net ([87.98.216.213]:42712 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755628Ab0LRQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 11:02:54 -0500
Message-ID: <4D0CDB28.8090809@example.com>
Date: Sat, 18 Dec 2010 17:02:48 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101211 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Why is networking GIT refusing me?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15792435045313638680
X-Ovh-Remote: 83.6.195.8 (abbf8.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried to update my Linux tree with the newest networking source vand 
tried to run:

git remote add networking 
master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master
git remote update

The second one asks me if the SSH key is valid, and then asks me for the 
root password which I obviously do not know and cannot update. Where to 
get newest networking source by GIT?

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Jak d³ugo trwa³a wojna sze¶ciodniowa miêdzy Izraelem a Egiptem?
- (po d³u¿szym namy¶le): Czterna¶cie dni.
NP: Peter Green Splinter Group - Big Change Is Gonna Come
NB: 2.6.37-rc6-git3
