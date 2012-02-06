Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916Ab2BFFFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 00:05:14 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:21241
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708Ab2BFFFM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 00:05:12 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz9371I542M1432N14ffOzz1202hzzz2dh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Changming-R66093 <r66093@freescale.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Ball <cjb@laptop.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Yutang-B14898 <B14898@freescale.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: RE: linux-next: build failure after merge of the final tree (mmc
 tree related)
Thread-Topic: linux-next: build failure after merge of the final tree (mmc
 tree related)
Thread-Index: AQHM5IldixbgtfxJn0uNJ9+oGRsW55YvTEBQ
Date: Mon, 6 Feb 2012 04:50:03 +0000
Message-ID: <110EED8CC96DFC488B7E717A2027A27C01B3F2@039-SN1MPN1-002.039d.mgd.msft.net>
References: <20120206153916.48adb1f48711f665274909b7@canb.auug.org.au>
In-Reply-To: <20120206153916.48adb1f48711f665274909b7@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
Chris' patch which defined the "platform_suspend" is needed.

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Monday, February 06, 2012 12:39 PM
> To: Chris Ball
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Huang
> Changming-R66093; Jiang Yutang-B14898; Anton Vorontsov
> Subject: linux-next: build failure after merge of the final tree (mmc
> tree related)
> 
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mmc/host/sdhci-of-esdhc.c:143:2: error: unknown field
> 'platform_suspend' specified in initializer
> drivers/mmc/host/sdhci-of-esdhc.c:143:2: warning: initialization from
> incompatible pointer type [enabled by default]
> drivers/mmc/host/sdhci-of-esdhc.c:143:2: warning: (near initialization
> for 'sdhci_esdhc_ops.get_timeout_clock') [enabled by default]
> drivers/mmc/host/sdhci-of-esdhc.c:144:2: error: unknown field
> 'platform_resume' specified in initializer
> drivers/mmc/host/sdhci-of-esdhc.c:144:2: warning: initialization from
> incompatible pointer type [enabled by default]
> drivers/mmc/host/sdhci-of-esdhc.c:144:2: warning: (near initialization
> for 'sdhci_esdhc_ops.platform_8bit_width') [enabled by default]
> 
> Caused by commit 4f6eeb41eee9 ("mmc: esdhc: Implement power management
> for ESDHC").  I can't see how that was ever even build tested ..
> 
> I have reverted that commit for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

