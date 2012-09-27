Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2I0IYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:24:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53217 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab2I0IYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120927075101.GM12592@arwen.pp.htv.fi>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-8-git-send-email-andriy.shevchenko@linux.intel.com>
	<20120927075101.GM12592@arwen.pp.htv.fi>
Date: Thu, 27 Sep 2012 11:24:30 +0300
Message-ID: <CAHp75Vcj=EXizjrEJ8FtYJF5SX_7fLpHUDVwJJtNT59mywG0Kg@mail.gmail.com>
Subject: Re: [PATCHv3 7/7] MAINTAINERS: add recently created files to dw_dmac section
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:51 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Sep 27, 2012 at 10:32:01AM +0300, Andy Shevchenko wrote:
>> Append myself to the mail entry of the section as well.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>  MAINTAINERS |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7dfd0eb..b87cbb1d 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -5999,10 +5999,10 @@ F:    drivers/tty/serial
>>
>>  SYNOPSYS DESIGNWARE DMAC DRIVER
>>  M:   Viresh Kumar <viresh.linux@gmail.com>
>> +M:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> this needs to be agreed with Viresh first, I guess. Not sure if it was
> done or not. If it was, sorry for the noise ;-)
Indeed, it's under discussion. I just have a talk with colleagues, and
they mostly convinced me in unnecessity of that change.

-- 
With Best Regards,
Andy Shevchenko
