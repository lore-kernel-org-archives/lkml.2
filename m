Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945959Ab2LFQrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:47:23 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47785 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2LFQrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:22 -0500
MIME-Version: 1.0
In-Reply-To: <20121206164054.GV2718@gmail.com>
References: <3db3266122f4c54f624477b3fb6763e5821bd3d0.1354807084.git.viresh.kumar@linaro.org>
	<20121206164054.GV2718@gmail.com>
Date: Thu, 6 Dec 2012 22:17:21 +0530
Message-ID: <CAKohpon3uW2N3Kaj_HkjVsUZ0+9oOHtPev=okyP50BxSKz7ntQ@mail.gmail.com>
Subject: Re: [PATCH V6] mfd: stmpe: Update DT support for stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 December 2012 22:10, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 06 Dec 2012, Viresh Kumar wrote:
>> +     pdata->id = -1;
>
> Perhaps PLATFORM_DEVID_AUTO would be better?

Why do we want to allocate device id's for it? Multiple devices
are already distinguished and so -1 would be better.

>> +     pdata->irq_trigger = IRQF_TRIGGER_NONE;
>> +
>
> There's no need for this. It's guaranteed to be zero by:
>
>   pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);

I kept it so that in future others don't think that we missed handling
of irq_trigger for DT case.

--
viresh
