Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2G3Jqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 05:46:36 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:38587 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab2G3Jqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 05:46:33 -0400
MIME-Version: 1.0
In-Reply-To: <501655F2.7070900@ti.com>
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
	<1343639400-28725-2-git-send-email-kishon@ti.com>
	<501655F2.7070900@ti.com>
Date: Mon, 30 Jul 2012 15:16:32 +0530
Message-ID: <CAAe_U6LWEiAE8TVVEQ5LcKy0_+J7Er2vP71MrQVrg=ZteyAeCw@mail.gmail.com>
Subject: Re: [PATCH v6 01/11] drivers: usb: otg: add a new driver for omap
 usb2 phy
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Shubhrajyoti <shubhrajyoti@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 30, 2012 at 3:07 PM, Shubhrajyoti <shubhrajyoti@ti.com> wrote:
> On Monday 30 July 2012 02:39 PM, Kishon Vijay Abraham I wrote:
>> +                     writel(~PHY_PD, phy->control_dev);
>> +                     /* XXX: add proper documentation for this delay */
>> +                     mdelay(200);
> Do you need this to be busy?
This might be called from interrupt context. This delay was initially
added in omap_phy_internal.c and I just inherited it.

Thanks
Kishon
