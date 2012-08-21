Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2HULbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:31:50 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:49790 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120Ab2HULbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:31:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120821104647.GU10347@arwen.pp.htv.fi>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
	<1345545940-2232-3-git-send-email-sourav.poddar@ti.com>
	<20120821104647.GU10347@arwen.pp.htv.fi>
Date: Tue, 21 Aug 2012 17:01:47 +0530
Message-ID: <CAKdam57p_K-ui1x+u-n07PQ8aweZocDsXoFTtdk_6CAVsC+xOg@mail.gmail.com>
Subject: Re: [PATCH 2/4] Input: keypad: Add smsc ece1099 keypad driver
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: balbi@ti.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 21, 2012 at 4:16 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Aug 21, 2012 at 04:15:38PM +0530, Sourav Poddar wrote:
>> +static struct platform_driver smsc_driver = {
>> +     .driver = {
>> +             .name   = "smsc-keypad",
>> +             .of_match_table = of_match_ptr(smsc_keypad_dt_match),
>> +             .owner  = THIS_MODULE,
>> +     },
>> +     .probe          = smsc_probe,
>> +     .remove         = smsc_remove,
>
> one extra comment which I forgot. You probably should put your remove on
> __devexit and add __devexit_p(smsc_remove) here.
>
yes, Will do it.
> --
> balbi
