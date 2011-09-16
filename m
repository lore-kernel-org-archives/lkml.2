Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1IPFrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 01:47:45 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:42940 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308Ab1IPFro convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 01:47:44 -0400
MIME-Version: 1.0
In-Reply-To: <4E729AFB.6010008@am.sony.com>
References: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com>
	<1316092970-2440-2-git-send-email-keshava_mgowda@ti.com>
	<1316092970-2440-3-git-send-email-keshava_mgowda@ti.com>
	<1316092970-2440-4-git-send-email-keshava_mgowda@ti.com>
	<1316092970-2440-5-git-send-email-keshava_mgowda@ti.com>
	<1316092970-2440-6-git-send-email-keshava_mgowda@ti.com>
	<4E729AFB.6010008@am.sony.com>
Date: Fri, 16 Sep 2011 11:17:42 +0530
Message-ID: <CAP05o4JK9zdZ8P5o0Di+obDwYjur0p=TC-n9weznqx_odMzycw@mail.gmail.com>
Subject: Re: [PATCH 5/5 v9] mfd: omap: usb: Runtime PM support
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: frank.rowand@am.sony.com
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 6:10 AM, Frank Rowand <frank.rowand@am.sony.com> wrote:
> On 09/15/11 06:22, Keshava Munegowda wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The usbhs core driver does not enable/disable the interface and
>> functional clocks; These clocks are handled by hwmod and runtime pm,
>> hence instead of the clock enable/disable, the runtime pm APIS are
>> used. however,the port clocks are handled by the usbhs core.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> Reviewed-by: Kevin Hilman <khilman@ti.com>
>> ---
>>  arch/arm/plat-omap/include/plat/usb.h |    3 -
>>  drivers/mfd/omap-usb-host.c           |  731 +++++++++++++--------------------
>>  drivers/usb/host/ehci-omap.c          |   17 +-
>>  drivers/usb/host/ohci-omap3.c         |   18 +-
>>  4 files changed, 295 insertions(+), 474 deletions(-)
>>
>> diff --git a/arch/arm/plat-omap/include/plat/usb.h b/arch/arm/plat-omap/include/plat/usb.h
>> index 17d3c93..2b66dc2 100644
>
> Patch 5/5 is white space mangled.  The tabs have been changed into spaces.
>
> -Frank

where exactly? I had checked before sending it , but i dint find any?
please let me know where exactly.

regards
keshava
