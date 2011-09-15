Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab1IONDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:03:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33606 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933535Ab1IONDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:03:50 -0400
Message-ID: <4E71F79C.6080900@ti.com>
Date: Thu, 15 Sep 2011 15:03:24 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com> <4E71CE5D.9030900@ti.com> <20110915102915.GJ6267@n2100.arm.linux.org.uk> <4E71EF56.3050503@ti.com> <20110915125107.GK6267@n2100.arm.linux.org.uk>
In-Reply-To: <20110915125107.GK6267@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/2011 2:51 PM, Russell King - ARM Linux wrote:
> On Thu, Sep 15, 2011 at 02:28:06PM +0200, Cousson, Benoit wrote:
>> The HW specs is obviously counting the IRQ number at the GIC interface.
>> That offset is not known outside the MPUSS. Please have a look at the
>> OMAP4430 TRM p4761 (NDA vM version).
>
> As far as I know, I have no access to that.  I've certainly never been
> pointed to any documentation on OMAP4.

That's easy to fix since the same information is in the public TRM 
(p3386 in that case). And here is the link:
http://focus.ti.com/pdfs/wtbu/OMAP4430_ES2.x_PUBLIC_TRM_vX.zip

Do not hesitate to ask if you never further information on OMAP SoC.

Regards,
Benoit
