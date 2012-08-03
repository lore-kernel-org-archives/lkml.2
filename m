Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2HCOl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:41:29 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:39080 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009Ab2HCOl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120803133602.GM8269@arwen.pp.htv.fi>
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
	<1343639400-28725-12-git-send-email-kishon@ti.com>
	<20120803133602.GM8269@arwen.pp.htv.fi>
Date: Fri, 3 Aug 2012 20:11:12 +0530
Message-ID: <CAAe_U6+KC8kWD8BHpE20oYEfTS5JegRgU8sqrj4JWVLdOFxLrg@mail.gmail.com>
Subject: Re: [PATCH v6 11/11] arm: omap: phy: remove unused functions from omap-phy-internal.c
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 3, 2012 at 7:06 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jul 30, 2012 at 02:40:00PM +0530, Kishon Vijay Abraham I wrote:
>> All the unnessary functions in omap-phy-internal is removed.
>> These functionality are now handled by omap-usb2 phy driver.
>>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Acked-by: Tony Lindgren <tony@atomide.com>
>
> Great stuff. I'll take this when we agree on the omap-usb2 phy driver.

Sure.

Thanks
Kishon
