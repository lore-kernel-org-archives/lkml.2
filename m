Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945963Ab2JLPxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:53:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59966 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945918Ab2JLPxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponS+mkj6rN6hzJC1FrbpSS+jWZBii4xQgN+4z2h=zFTWA@mail.gmail.com>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	<9688d98010716880c1bbd966ead312c446282204.1350051925.git.viresh.kumar@linaro.org>
	<1350053897.10584.172.camel@smile>
	<CAKohponS+mkj6rN6hzJC1FrbpSS+jWZBii4xQgN+4z2h=zFTWA@mail.gmail.com>
Date: Fri, 12 Oct 2012 18:53:14 +0300
Message-ID: <CAHp75VdNVyWxvnHDFjg_5vC95M_LwJYUDLQb+NmBA6GRVsea9g@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 6:18 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 12 October 2012 20:28, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> On Fri, 2012-10-12 at 20:01 +0530, Viresh Kumar wrote:
>
>>> +     if (last_dw) {
>>> +             if ((last_bus_id == param) && (last_dw == dw))
>>> +                     return false;
>>> +     }
1. This is an equivalent of
if (last_dw && (last_bus_id == ... ) && (last_dw == dw))
 return false;
2. In case dw is always non-NULL the last_dw == dw is false if last_dw is NULL.

Where am I wrong?

> You are already drunk.
Not yet, but tired.

-- 
With Best Regards,
Andy Shevchenko
