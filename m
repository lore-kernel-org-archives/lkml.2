Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2HHBnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:43:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35848 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2HHBnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FEBDE@DQHE02.ent.ti.com>
References: <1343824834.3859.2.camel@phoenix> <CAK5ve-+dvpQqj1q9QF8nfST0Ff=W7WCO=_jYdGi7gOjsWO+93w@mail.gmail.com>
 <A874F61F95741C4A9BA573A70FE3998FEBDE@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 8 Aug 2012 09:42:50 +0800
X-Google-Sender-Auth: oLyjPIX6Xky_qNDzsT1S8vpWRQI
Message-ID: <CAK5ve-K8BVLYzRyy+LqVyYtirzTXqrYz9a5-g22xV6k1k6sFoA@mail.gmail.com>
Subject: Re: [PATCH RFT] leds: lp8788: Fix updating scale configuration bits
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 4:09 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>> > We need to do left shift (cfg->num + LP8788_ISINK_SCALE_OFFSET) bits
>> for
>> > updating scale configuration.
>> >
>> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> > ---
>>
>> Milo, I think this patch from Axel is reasonable. could you please
>> take a look at this?
>>
>> -Bryan
>
> Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> Tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>
>
> Thanks,
> Milo -

Great, Applied

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
