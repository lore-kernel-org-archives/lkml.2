Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2GJHGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:06:06 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:46384 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab2GJHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:05:45 -0400
Message-ID: <4FFBD43F.4010704@ti.com>
Date: Tue, 10 Jul 2012 12:35:35 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "hvaibhav@ti.com" <hvaibhav@ti.com>
Subject: Re: [PATCH v1 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
References: <1340884267-28908-1-git-send-email-kishon@ti.com>	<1340884267-28908-2-git-send-email-kishon@ti.com>	<4FFBC1D0.5030506@ti.com>	<D958900912E20642BCBC71664EFECE3E6DDAD9FF96@BGMAIL02.nvidia.com> <CAAe_U6Kx8o6sHgpev3UEAou7tuNDt9iL0+hcyOVDb0WsCsSwKg@mail.gmail.com>
In-Reply-To: <CAAe_U6Kx8o6sHgpev3UEAou7tuNDt9iL0+hcyOVDb0WsCsSwKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012 12:18 PM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>
> On Tue, Jul 10, 2012 at 11:33 AM, Venu Byravarasu
> <vbyravarasu@nvidia.com>  wrote:
>>>> +
>>>> +#ifdef CONFIG_PM
>>
>> Should it not be CONFIG_PM_SLEEP instead of just CONFIG_PM?
>
> Why? I think we should have CONFIG_PM_SLEEP only when we have
> *suspend*, *resume* hooks. But this driver has only *runtime_suspend*
> and *runtime_resume* hooks.

CONFIG_PM_RUNTIME maybe then?
