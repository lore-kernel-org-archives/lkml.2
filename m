Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab1FANjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:39:03 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46915 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891Ab1FANi6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110601133128.GD2409@legolas.emea.dhcp.ti.com>
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-3-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-4-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-5-git-send-email-keshava_mgowda@ti.com>
	<20110601133128.GD2409@legolas.emea.dhcp.ti.com>
Date: Wed, 1 Jun 2011 19:08:49 +0530
Message-ID: <BANLkTimo8mF43SuyLAzdu18fD2di1Gurmw@mail.gmail.com>
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and ohci
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, khilman@ti.com,
        b-cousson@ti.com, paul@pwsan.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 7:01 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Jun 01, 2011 at 06:57:27PM +0530, Keshava Munegowda wrote:
>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>> index 43de12a..32d19e2 100644
>> --- a/drivers/mfd/omap-usb-host.c
>> +++ b/drivers/mfd/omap-usb-host.c
>> @@ -146,6 +146,10 @@
>>  #define is_ehci_hsic_mode(x) (x == OMAP_EHCI_PORT_MODE_HSIC)
>>
>>
>> +/* USBHS state bits */
>> +#define OMAP_USBHS_INIT              0
>> +#define OMAP_USBHS_SUSPEND   4
>
> #define OMAP_USBHS_INIT         BIT(0)
> #define OMAP_USBHS_SUSPEND      BIT(1)
>
> ???

yes, I will do.. please comment on other patches too

keshava
