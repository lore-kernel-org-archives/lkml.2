Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1IPRri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:47:38 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:17797
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725Ab1IPRrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:47:36 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zzbb2dK9371K148cM1432N98dKzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E738B9A.3050908@am.sony.com>
Date: Fri, 16 Sep 2011 10:47:06 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
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
References: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com>	<1316092970-2440-2-git-send-email-keshava_mgowda@ti.com>	<1316092970-2440-3-git-send-email-keshava_mgowda@ti.com>	<1316092970-2440-4-git-send-email-keshava_mgowda@ti.com>	<1316092970-2440-5-git-send-email-keshava_mgowda@ti.com>	<1316092970-2440-6-git-send-email-keshava_mgowda@ti.com>	<4E729AFB.6010008@am.sony.com>	<CAP05o4JK9zdZ8P5o0Di+obDwYjur0p=TC-n9weznqx_odMzycw@mail.gmail.com> <CAP05o4JxUPBM=PqguRL8-Mvgyf=wgxvg7UWMcRo2WXe2jmCUVA@mail.gmail.com>
In-Reply-To: <CAP05o4JxUPBM=PqguRL8-Mvgyf=wgxvg7UWMcRo2WXe2jmCUVA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/11 00:31, Munegowda, Keshava wrote:
> On Fri, Sep 16, 2011 at 11:17 AM, Munegowda, Keshava
> <keshava_mgowda@ti.com> wrote:
>> On Fri, Sep 16, 2011 at 6:10 AM, Frank Rowand <frank.rowand@am.sony.com> wrote:
>>> On 09/15/11 06:22, Keshava Munegowda wrote:
>>>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>>>
>>>> The usbhs core driver does not enable/disable the interface and
>>>> functional clocks; These clocks are handled by hwmod and runtime pm,
>>>> hence instead of the clock enable/disable, the runtime pm APIS are
>>>> used. however,the port clocks are handled by the usbhs core.
>>>>
>>>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>>>> Reviewed-by: Kevin Hilman <khilman@ti.com>
>>>> ---
>>>>  arch/arm/plat-omap/include/plat/usb.h |    3 -
>>>>  drivers/mfd/omap-usb-host.c           |  731 +++++++++++++--------------------
>>>>  drivers/usb/host/ehci-omap.c          |   17 +-
>>>>  drivers/usb/host/ohci-omap3.c         |   18 +-
>>>>  4 files changed, 295 insertions(+), 474 deletions(-)
>>>>
>>>> diff --git a/arch/arm/plat-omap/include/plat/usb.h b/arch/arm/plat-omap/include/plat/usb.h
>>>> index 17d3c93..2b66dc2 100644
>>>
>>> Patch 5/5 is white space mangled.  The tabs have been changed into spaces.
>>>
>>> -Frank
>>
> 
> Hi Frank
>           I tried the checkpatch with --strict option; its not showing
> anything here. may be some problem with your editor/browser.

It must be my email server, because when I pull the patch from an archive
it has tabs.  Weird that only the fifth patch is being munged for me...

Thanks for checking!

-Frank

