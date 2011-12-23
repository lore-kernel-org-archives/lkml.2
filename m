Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1LWLQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:16:52 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:48524 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756733Ab1LWLQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:16:45 -0500
Message-ID: <4EF46304.8070806@st.com>
Date: Fri, 23 Dec 2011 12:16:20 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [net-next] stmmac: fix missing module license in the main.
References: <4EF3DB45.30401@xenotime.net> <1324636267-25533-1-git-send-email-peppe.cavallaro@st.com>
In-Reply-To: <1324636267-25533-1-git-send-email-peppe.cavallaro@st.com>
Content-Type: multipart/mixed;
 boundary="------------030208080706080200000805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030208080706080200000805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sorry I had forgotten to add you on copy.

Peppe

p.s. patch attached here too.

On 12/23/2011 11:31 AM, Giuseppe CAVALLARO wrote:
> This patch fixes the following warning raised
> when compile:
> 
> WARNING: modpost: missing MODULE_LICENSE()
> in drivers/net/ethernet/stmicro/stmmac/stmmac.o
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index b314592..3738b47 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2039,3 +2039,7 @@ err:
>  
>  __setup("stmmaceth=", stmmac_cmdline_opt);
>  #endif
> +
> +MODULE_DESCRIPTION("STMMAC 10/100/1000 Ethernet device driver");
> +MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
> +MODULE_LICENSE("GPL");



--------------030208080706080200000805
Content-Type: text/x-patch;
 name="0001-stmmac-fix-missing-module-license-in-the-main.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-stmmac-fix-missing-module-license-in-the-main.patch"

>From c24fa5e2784f85e6170a495bc42dea9a854cb3da Mon Sep 17 00:00:00 2001
From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Date: Fri, 23 Dec 2011 11:25:13 +0100
Subject: [net-next] stmmac: fix missing module license in the main.

This patch fixes the following warning raised
when compile:

WARNING: modpost: missing MODULE_LICENSE()
in drivers/net/ethernet/stmicro/stmmac/stmmac.o

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b314592..3738b47 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2039,3 +2039,7 @@ err:
 
 __setup("stmmaceth=", stmmac_cmdline_opt);
 #endif
+
+MODULE_DESCRIPTION("STMMAC 10/100/1000 Ethernet device driver");
+MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.4.4


--------------030208080706080200000805--
