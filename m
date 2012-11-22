Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2KVS7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:59:45 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58284 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2KVS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:59:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh2x=niXPCeg1dWtmjDjms_8ndYD7pzGY37k36e8=D8Km7gqQ@mail.gmail.com>
References: <1352675000-29627-1-git-send-email-jon.mason@intel.com>
	<CAOh2x=niXPCeg1dWtmjDjms_8ndYD7pzGY37k36e8=D8Km7gqQ@mail.gmail.com>
Date: Thu, 22 Nov 2012 10:55:27 +0530
X-Google-Sender-Auth: fR5qGHqBQL5JxE1VPpUi4imgZrA
Message-ID: <CAOh2x==rW9NNJ6kxRF13D=eYVmHsEhCHck7ecDpe9YcrSm8mXA@mail.gmail.com>
Subject: Re: [PATCH v2] dmatest: Fix NULL pointer dereference on ioat
From: viresh kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 8:17 AM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Mon, Nov 12, 2012 at 4:33 AM, Jon Mason <jon.mason@intel.com> wrote:
>> device_control is an optional and not implemented in all DMA drivers.
>> Any calls to these will result in a NULL pointer dereference.  dmatest
>> makes two of these calls when completing the kernel thread and removing
>> the module.  These are corrected by calling the dmaengine_device_control
>> wrapper and checking for a non-existant device_control function pointer
>> there.
>>
>> Signed-off-by: Jon Mason <jon.mason@intel.com>
>> CC: Vinod Koul <vinod.koul@intel.com>
>> CC: Dan Williams <djbw@fb.com>

> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

Vinod/Dan: I couldn't find this patch and
https://patchwork.kernel.org/patch/1720971/
in you trees. Are you pushing them for 3.8?

--
viresh
