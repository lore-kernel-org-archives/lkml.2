Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab2JLPS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:18:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53845 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964798Ab2JLPS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <1350053897.10584.172.camel@smile>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	<9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
	<1350053897.10584.172.camel@smile>
Date: Fri, 12 Oct 2012 20:48:56 +0530
Message-ID: <CAKohponS+mkj6rN6hzJC1FrbpSS+jWZBii4xQgN+4z2h=zFTWA@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 20:28, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Fri, 2012-10-12 at 20:01 +0530, Viresh Kumar wrote:

>> +     if (last_dw) {
>> +             if ((last_bus_id == param) && (last_dw == dw))
>> +                     return false;
>> +     }

> Just came to my mind.
> dw can't be NULL, can't it?
> Then
> if (last_dw) {
> ...
> }
> is unneeded.

dw can't be but last_dw can be, which we are making NULL when
we find a channel :)

You are already drunk.

--
viresh
