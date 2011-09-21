Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1IUT3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:29:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42216 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1IUT3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:29:14 -0400
Message-ID: <4E7A3AF0.1020809@ti.com>
Date: Wed, 21 Sep 2011 21:28:48 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "dave.martin@linaro.org" <dave.martin@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] ARM: gic: add OF based initialization
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com> <1316550244-3655-4-git-send-email-robherring2@gmail.com> <4E7A1BCA.1090006@ti.com> <4E7A252F.2000402@gmail.com>
In-Reply-To: <4E7A252F.2000402@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/2011 7:55 PM, Rob Herring wrote:

[...]

> I fixed that in the prior series and tglx picked it up, so I did not
> repost. It should hit mainline for 3.1, but I haven't verified if it is
> in yet. Sorry for the confusion, I should have mentioned that.

OK, I remember now as well that Thomas took patched 2 patches from your 
previous one. And I found it:
https://lkml.org/lkml/2011/9/14/190

Now, I have to find why the twl interrupt-controller is not working 
anymore even with that fix.

Almost-Tested-by: Benoit Cousson <b-cousson@ti.com>

Thanks,
Benoit

