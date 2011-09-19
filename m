Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab1ISRo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:44:59 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:46206 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1ISRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:44:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110919133301.GR16381@n2100.arm.linux.org.uk>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
 <4E71CE5D.9030900@ti.com> <4E71F978.6020402@gmail.com> <4E72030F.1090300@ti.com>
 <4E722B2D.4050307@gmail.com> <4E770FA6.2070305@ti.com> <20110919133301.GR16381@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 19 Sep 2011 11:44:38 -0600
X-Google-Sender-Auth: _8BLI1wBEzNWC-U6SeF49HQPu7A
Message-ID: <CACxGe6soJQu5Cvc+ZANVS=WXwACzG69GPGF9fAuVLDB-sUurUw@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Cousson, Benoit" <b-cousson@ti.com>, Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 7:33 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Sep 19, 2011 at 11:47:18AM +0200, Cousson, Benoit wrote:
>> Since the cpumask is not relevant for the SPI, maybe having two
>> interrupt controllers will be more relevant. Or maybe 3, since there is
>> some SGIs as well.
>
> I don't think anyone uses SGIs outside of the common SMP code.
> Therefore they're handled entirely separately for the root GIC.
>
> (If there's two GICs - some platforms do have two - then the SGIs on
> the non-root GIC are unused.)

...and since SGIs aren't external HW inputs to the GIC, there really
isn't any need to reflect them in the GIC DT binding.

g.
