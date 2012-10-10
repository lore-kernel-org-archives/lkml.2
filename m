Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2JJJIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:08:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48549 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2JJJIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <1349859841.10584.122.camel@smile>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349859841.10584.122.camel@smile>
Date: Wed, 10 Oct 2012 14:38:10 +0530
X-Google-Sender-Auth: 9IZnnx2OvwkHv1admTrRM0sDC8A
Message-ID: <CAOh2x=mNiL4k=v3YGexq7YMZUx131QWBpm11QXupnWLUPuKU4Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] dmaengine: dw_dmac: use helper macro module_platform_driver()
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, balbi@ti.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 2:34 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Tue, 2012-10-02 at 14:41 +0300, Andy Shevchenko wrote:
>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>
>> Since v3.2 we have nice macro to define the platform driver's init and exit
>> calls. This patch simplifies the dw_dmac driver by using that macro.
>
> Actually we can't do this. It will break initialization of some other
> drivers.

why?
