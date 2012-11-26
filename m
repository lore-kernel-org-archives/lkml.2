Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2KZJLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:11:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43367 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab2KZJLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:11:52 -0500
Message-ID: <50B33252.3060709@ti.com>
Date: Mon, 26 Nov 2012 10:11:46 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 1/3] pwm: Remove pwm-twl6030 driver
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com> <1353405382-9226-2-git-send-email-peter.ujfalusi@ti.com> <20121123150548.GC16810@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121123150548.GC16810@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 04:05 PM, Thierry Reding wrote:
> On Tue, Nov 20, 2012 at 10:56:20AM +0100, Peter Ujfalusi wrote:
>> This driver only supported the Charging indicator LED.
>> New set of drivers going to provide support for both PWMs and LEDs for twl4030
>> and twl6030 series of PMICs.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  drivers/pwm/Kconfig       |   9 ---
>>  drivers/pwm/Makefile      |   1 -
>>  drivers/pwm/pwm-twl6030.c | 184 ----------------------------------------------
>>  3 files changed, 194 deletions(-)
>>  delete mode 100644 drivers/pwm/pwm-twl6030.c
> 
> I think I'd rather see this patch as the last in the series to make sure
> that no functionality is dropped across the series.

Sure, I will move it as a last patch.

-- 
Péter
