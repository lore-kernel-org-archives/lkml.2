Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2LJPDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:03:25 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38293 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2LJPDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokv+eXJNQAfu6SjYA9Um__NikhMAceKmr1KHUehq85A4Q@mail.gmail.com>
References: <1355151586-5207-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAKohpokv+eXJNQAfu6SjYA9Um__NikhMAceKmr1KHUehq85A4Q@mail.gmail.com>
Date: Mon, 10 Dec 2012 17:03:12 +0200
Message-ID: <CAHp75Vejm7_49xHJ=j-z5seXCBuTvpyknQx0UTT9_v-ixMTnMw@mail.gmail.com>
Subject: Re: [PATCHv3] dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        spear-devel <spear-devel@list.st.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 5:01 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 10 December 2012 20:29, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> The same information could be exctracted from the struct dma_chan.
>> The patch introduces helper function dwc_get_data_width() as well.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> So sorry for taking this long :(

No problem, it was a good review.

> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
With Best Regards,
Andy Shevchenko
