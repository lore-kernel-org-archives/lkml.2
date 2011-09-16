Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023Ab1IPAkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 20:40:53 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:6786
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab1IPAkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 20:40:51 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dK1432N98dKzz1202hzz8275bhz2fh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E729AFB.6010008@am.sony.com>
Date: Thu, 15 Sep 2011 17:40:27 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Keshava Munegowda <keshava_mgowda@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        "gadiyar@ti.com" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "khilman@ti.com" <khilman@ti.com>, "paul@pwsan.com" <paul@pwsan.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "vishwanath.bs@ti.com" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 5/5 v9] mfd: omap: usb: Runtime PM support
References: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com> <1316092970-2440-2-git-send-email-keshava_mgowda@ti.com> <1316092970-2440-3-git-send-email-keshava_mgowda@ti.com> <1316092970-2440-4-git-send-email-keshava_mgowda@ti.com> <1316092970-2440-5-git-send-email-keshava_mgowda@ti.com> <1316092970-2440-6-git-send-email-keshava_mgowda@ti.com>
In-Reply-To: <1316092970-2440-6-git-send-email-keshava_mgowda@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/11 06:22, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> 
> The usbhs core driver does not enable/disable the interface and
> functional clocks; These clocks are handled by hwmod and runtime pm,
> hence instead of the clock enable/disable, the runtime pm APIS are
> used. however,the port clocks are handled by the usbhs core.
> 
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> ---
>  arch/arm/plat-omap/include/plat/usb.h |    3 -
>  drivers/mfd/omap-usb-host.c           |  731 +++++++++++++--------------------
>  drivers/usb/host/ehci-omap.c          |   17 +-
>  drivers/usb/host/ohci-omap3.c         |   18 +-
>  4 files changed, 295 insertions(+), 474 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/usb.h b/arch/arm/plat-omap/include/plat/usb.h
> index 17d3c93..2b66dc2 100644

Patch 5/5 is white space mangled.  The tabs have been changed into spaces.

-Frank

