Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2LLJAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:00:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60833 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2LLJAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:00:48 -0500
Message-ID: <50C847AC.3030100@ti.com>
Date: Wed, 12 Dec 2012 10:00:28 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] leds: leds-pwm: Add device tree bindings
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com> <1355133637-2784-5-git-send-email-peter.ujfalusi@ti.com> <20121211072545.GD8294@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121211072545.GD8294@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 08:25 AM, Thierry Reding wrote:
>> +static const struct of_device_id of_pwm_leds_match[] = {
>> +	{ .compatible = "pwm-leds", },
>> +	{},
>> +};
> 
> Doesn't this cause a compiler warning for !OF builds?

This is not causing any compiler warnings.

-- 
Péter
