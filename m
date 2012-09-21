Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2IUGEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:04:30 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60244 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab2IUGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:04:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=n-26MSV4yxse=+iT=3ATa2Qd858QuWmRiRmjwnzxmFhA@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==MwD6RVnShoD0zJaAPZ814bAGDx6BEjGsK=9M+LxMxBA@mail.gmail.com>
	<1348133748.13371.33.camel@smile>
	<CAOh2x=n-26MSV4yxse=+iT=3ATa2Qd858QuWmRiRmjwnzxmFhA@mail.gmail.com>
Date: Fri, 21 Sep 2012 11:34:27 +0530
X-Google-Sender-Auth: -Bl4p1yPwEvuLQt0TimgTDoufzQ
Message-ID: <CAOh2x==Fud7k6VcxiiS2VBKsbfOJLZBsX=rtdV+QfdyYQEoY=Q@mail.gmail.com>
Subject: Re: [PATCH 3/7] dw_dmac: get number of channels from hardware if possible
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 3:10 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Thu, Sep 20, 2012 at 3:05 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> On Tue, 2012-09-18 at 12:20 +0530, viresh kumar wrote:
>>> > @@ -1392,23 +1396,32 @@ static int __devinit dw_probe(struct platform_device *pdev)
>>> > +       dw_params = dma_raw_readl(regs, DW_PARAMS);
>>>
>>> Is this valid for every SoC implementation. What if this configuration
>>> is not valid
>>> for a particular SoC and it is invalid to access this address? Or this
>>> gives a invalid
>>> value instead of returning 0?
>
>> Actually I didn't get it clearly from the documentation. We have only
>> one test report from Hein until now.
>
> @Shiraz: Can you please verify reading this register from u-boot? This
> is important before we apply this patch to linux-next.

Ok. I have verified from the documentation. This are valid registers for SPEAr.
@Shiraz: No need to check now. :)

--
viresh
