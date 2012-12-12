Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2LLMrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:47:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47247 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2LLMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:47:46 -0500
Message-ID: <50C87CED.3070705@ti.com>
Date: Wed, 12 Dec 2012 13:47:41 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] gpio: twl4030: Correct status reporting for outputs
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com> <CACRpkdYZcEpN-BJy=3DPAQL+QgR+EyNeyABtAPE96+2hYxOQwQ@mail.gmail.com> <50C86691.60005@ti.com> <CACxGe6uMabhuKAW6P+Zow3NoviM2NyYGjDh+--r9ndEyiSkdAg@mail.gmail.com>
In-Reply-To: <CACxGe6uMabhuKAW6P+Zow3NoviM2NyYGjDh+--r9ndEyiSkdAg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 12:45 PM, Grant Likely wrote:
> I will take a look at it this week

Thanks

> but I cannot pick it up for v3.8 unless it is a regression bug fix from
> v3.6. It will have to wait for v3.9 and it can be merged into linux-next
> after the v3.8 merge window closes.

3.9 is fine. the gpio-twl4030 never reported the output state correctly, I
just found it out while doing some cleanups around the twl-core and board files.

Thanks,
Péter
