Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031379Ab2K3R2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:28:19 -0500
Received: from smtp103.biz.mail.ne1.yahoo.com ([98.138.207.10]:37953 "HELO
	smtp103.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933514Ab2K3R2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:28:13 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5mqmKlwVM1mUeZhgFBihC74xCUg1hHxQNs2T9s3mhUOQhWY
 0CjrIw8YH0CDYXDPRGKN6JgFkWYz3FhLagAUICjsMaSZfLRIhWnOIoA8rmcE
 _P91A.Nh5aTdXrJMiVOS4Rztpn5RaGCMTXPyGe0jc5DdV9IgW.Of2CyUKmMc
 08RLrxjjOWhGvdarR0J2EIeg5MaVpomsilX8eo5HIqi8JB1iILj9ce.qi6l_
 bfGR_ah94X7PwmVEt1L_czu3d2pXvYs2rR5msCpDsI7LazchhzGoFjjKYWqG
 L2TMbdBsAYYhScy4Tq.UH_5xf2xV.q4aLAkOSvSrb84Kadjh5s5THwi.w.h2
 6asBNaLYLKBeaBG3FkFaaX6ZM2tJqxyVNJZnTgCqXbXIL588ZTOKI3HRwu_B
 8ie2fY2da.KglriOGzMoeYF_Ma2CY3CGJ1OSnwBFUY5SoiHPdhmJYgZvnjK0
 uPlwL3MAaqSwSaH0ziI.cNNN0_ap2zWRw6j_F7Ula6Ucgex7xqG2cI86FvAt
 g
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50B8ECB3.2090801@schaufler-ca.com>
Date: Fri, 30 Nov 2012 09:28:19 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Paul Moore <paul@paul-moore.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] Smack: Add missing depends on INET in Kconfig
References: <20121129174057.99da02b15426c76054d05592@canb.auug.org.au> <50B7F846.70202@infradead.org> <3694027.VYznNcdp7C@sifl> <2664553.2TRaVqlkGg@sifl> <50B8E4E6.2040901@xenotime.net>
In-Reply-To: <50B8E4E6.2040901@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because NETLABEL depends on INET SECURITY_SMACK
has to explicitly call out the dependency.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 security/smack/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/security/smack/Kconfig b/security/smack/Kconfig
index 9fb14ef..1be1088 100644
--- a/security/smack/Kconfig
+++ b/security/smack/Kconfig
@@ -1,5 +1,6 @@
 config SECURITY_SMACK
 	bool "Simplified Mandatory Access Control Kernel Support"
+	depends on INET
 	depends on NET
 	depends on SECURITY
 	select NETLABEL

