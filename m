Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2G3KEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:04:35 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:33884 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774Ab2G3KEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:04:32 -0400
Message-ID: <50165C27.3010107@ti.com>
Date: Mon, 30 Jul 2012 15:34:23 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
References: <1343639400-28725-1-git-send-email-kishon@ti.com> <1343639400-28725-2-git-send-email-kishon@ti.com> <501655F2.7070900@ti.com> <CAAe_U6LWEiAE8TVVEQ5LcKy0_+J7Er2vP71MrQVrg=ZteyAeCw@mail.gmail.com>
In-Reply-To: <CAAe_U6LWEiAE8TVVEQ5LcKy0_+J7Er2vP71MrQVrg=ZteyAeCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2012 03:16 PM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>
> On Mon, Jul 30, 2012 at 3:07 PM, Shubhrajyoti <shubhrajyoti@ti.com> wrote:
>> On Monday 30 July 2012 02:39 PM, Kishon Vijay Abraham I wrote:
>>> +                     writel(~PHY_PD, phy->control_dev);
>>> +                     /* XXX: add proper documentation for this delay */
>>> +                     mdelay(200);
>> Do you need this to be busy?
> This might be called from interrupt context. This delay was initially
> added in omap_phy_internal.c and I just inherited it.
Thanks for the explanation.

> Thanks
> Kishon

