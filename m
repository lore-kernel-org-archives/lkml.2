Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2EXBey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:34:54 -0400
Received: from nm16.access.bullet.mail.mud.yahoo.com ([66.94.237.217]:20957
	"HELO nm16.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751167Ab2EXBew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:34:52 -0400
X-Yahoo-Newman-Id: 711564.15350.bm@smtp105.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: smksypoVM1l2aItIMrzKasphB8dgGvy70Nj1H5UCIRmWSlY
 422emVa4_NbYjYuTeEBz8ZJjeQv9M1Z9W.lEtklb9O_dNPf9WncAksADCDNl
 qVI3phx9Ar2b.cASVsmkLuBkiH8jf6JiAv9m2Y5fTcYmlgw68poezDQ_A6v8
 sZx3CUaHhl0Gcy.cnDBaSJC.IXOxth_OpGiLSEyrtLTOZ86TSO4ty031eBG4
 qyNY2itQKot1ynNl6.m1LTDZzt9jRVwbMa7oUR4dx4pYq5oo9ydZxz9OTjUv
 o2dZJEqMSHtjhfgkxqANnRcctyNyjBgD563b21Ev3MTgjcWDaJXyHmW.T.GS
 wMeClCubpMCSNn4rcef00QU31OYHcfdxbegjptKHH232k7fhByRm7rvMTxjC
 NsVE07pPNw9gnZgljOdse1kmp0jl7J0Mm6xsKpilWS_s0K2XgS5evodcOffJ
 CHRsUFZZTi4O_OFx2c.toyOHQxESgZMjLqUzROJZnAs4XgLu06X6liTPwCuh
 uYNrPD1r1Y5LXlJz.k0vF4nO6Rv2KY3QgMs7GejjQuSDA2j_S8CuZHKs.Qug
 7qxPUsab5JWCvfAXnq7VY
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FBD903C.7080903@schaufler-ca.com>
Date: Wed, 23 May 2012 18:34:52 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>
CC: LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: Maintainer Record
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: Maintainer Record

Add a maintainer record for the Smack LSM.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d7ca204..ccc8a14 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6133,6 +6133,15 @@ S:	Maintained
 F:	include/linux/sl?b*.h
 F:	mm/sl?b.c
 
+SMACK SECURITY MODULE
+M:	Casey Schaufler <casey@schaufler-ca.com>
+L:	linux-security-module@vger.kernel.org
+W:	http://schaufler-ca.com
+T:	git git://git.gitorious.org/smack-next/kernel.git
+S:	Maintained
+F:	Documentation/security/Smack.txt
+F:	security/smack/
+
 SMC91x ETHERNET DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes


