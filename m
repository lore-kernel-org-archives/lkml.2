Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2I0DrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:47:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42404 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2I0DrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:47:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Vc_vQuRewt=o-C_fay5BF6GPG3bn9X44sOEsUrypY-krg@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=m0bnhRBSSJNJQAiu54Dyu=0=2gG=-0AstUT815_wh9Bw@mail.gmail.com>
	<CAHp75Vc_vQuRewt=o-C_fay5BF6GPG3bn9X44sOEsUrypY-krg@mail.gmail.com>
Date: Thu, 27 Sep 2012 09:17:22 +0530
X-Google-Sender-Auth: aXK2os4lgk2zT4aZ2E-fC1ovgGY
Message-ID: <CAOh2x=nsSr-69JDfgd4qTCXa0Jw3u-NK2Lcnqp9Voxk9XRa4gw@mail.gmail.com>
Subject: Re: [PATCHv2 1/4] dmaengine: dw_dmac: convert to platform driver
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:30 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Sep 26, 2012 at 5:13 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
>> On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> wrote:
>>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>>
>>> This driver could be used on different platforms. Thus, we converted it to be
>>> a platform driver. The HAVE_CLK dependency is dropped away as well.
>>
>> Commit log and patch content don't match. :(
>> We aren't converting it to a platform driver, it is already one.
> Okay, any suggestion for this part?

Simply say:

dmaengine: dw_dmac: Use helper macro module_platform_driver()
