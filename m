Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1CUMwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:52:03 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:52897 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1CUMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:52:01 -0400
X-SpamScore: -1
X-BigFish: VS-1(zz1432N98dN1447Rzz1202hzzz2dh2a8h637h668h7fcim61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 21 Mar 2011 20:52:34 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <linaro-dev@lists.linaro.org>,
        <sameo@linux.intel.com>, <patches@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] make sdhci device drivers self registered
Message-ID: <20110321125233.GA28098@S2100-06.ap.freescale.net>
References: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
 <201103211339.45305.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201103211339.45305.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 01:39:45PM +0100, Arnd Bergmann wrote:
[...]
> 
> Hi Shawn,
> 
Hi Arnd,

> The changes you make look very nice, great work there!
> 
> I think the split of the series into five patches is not ideal
> because you have more interdependencies than necessary, and it's
> not clear that the series can be safely bisected, especially
> with the way you do all the Kconfig/Makefile updates at the
> end.
> 
> A nicer way to partition the series would be
> 
> 1.   Add sdhci_pltfm_init helper
> 2-5. Convert each of the users, including the respective
>      Kconfig/Makefile changes
> 6.   remove obsolete code from sdhci-pltfm.c
> 
> As I said, that's just a detail and the end result is the same.
> If you don't get any other feedback and Chris is happy with the
> changes, I wouldn't expect you to reshuffle all the patches just
> for this.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
Actually, I knew there should be better partition of the patch set,
and it just did not come into my mind :)  You suggestion does look
better.  I would take it in the next spin.

Thanks for the suggestion.

-- 
Regards,
Shawn

