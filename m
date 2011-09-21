Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1IUU1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:27:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47681 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1IUU1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:27:36 -0400
Message-ID: <4E7A48A3.5090602@ti.com>
Date: Wed, 21 Sep 2011 22:27:15 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "dave.martin@linaro.org" <dave.martin@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: gic: add OF based initialization
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com> <1316550244-3655-4-git-send-email-robherring2@gmail.com> <4E7A1BCA.1090006@ti.com> <4E7A252F.2000402@gmail.com> <4E7A3AF0.1020809@ti.com>
In-Reply-To: <4E7A3AF0.1020809@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/2011 9:28 PM, Cousson, Benoit wrote:
> On 9/21/2011 7:55 PM, Rob Herring wrote:
>
> [...]
>
>> I fixed that in the prior series and tglx picked it up, so I did not
>> repost. It should hit mainline for 3.1, but I haven't verified if it is
>> in yet. Sorry for the confusion, I should have mentioned that.
>
> OK, I remember now as well that Thomas took patched 2 patches from your
> previous one. And I found it:
> https://lkml.org/lkml/2011/9/14/190
>
> Now, I have to find why the twl interrupt-controller is not working
> anymore even with that fix.

This is much better with the proper #interrupt-cells size:-)

> Almost-Tested-by: Benoit Cousson<b-cousson@ti.com>

Tested-by: Benoit Cousson<b-cousson@ti.com>

With a still very limited number of OMAP4 peripherals for the moment.

Regards,
Benoit

