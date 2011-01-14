Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab1ANRIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:08:32 -0500
Received: from 63.mail-out.ovh.net ([91.121.185.56]:36025 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752043Ab1ANRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:08:28 -0500
Message-ID: <4D308308.8090103@example.com>
Date: Fri, 14 Jan 2011 18:08:24 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Will you make your code buildable?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 9442078095423467919
X-Ovh-Remote: 95.49.240.53 (afjg53.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter, hello all,

I CC LKML, because maybe other are uding Peter's code also. I get 
following code when I merge your code to Linus tree:

mm/migrate.c: In function ‘unmap_and_move_huge_page’:
mm/migrate.c:845: error: ‘rcu_locked’ undeclared (first use in this 
function)
mm/migrate.c:845: error: (Each undeclared identifier is reported only once
mm/migrate.c:845: error: for each function it appears in.)

I didn't manage to repair it by myself. Will you fix it?

Regards,

Piotr Hosowicz
-- 
- Obiecali zbudowac 3 miliony mieszkan! I nie zbudowali!
- Ale to bardzo dobrze, ze nie zbudowali! Nie od tego jest panstwo!
- Kwasniewski obiecywal nie 3, a 10 milionow mieszkan!
- No to wyglada na to, ze Kwasniewski zbudowal siedem,
   a Kaczynscy teraz musza dobudowac trzy miliony.
NP: Peter Green Splinter Group - Indians
NB: 2.6.37-git11-corr2
