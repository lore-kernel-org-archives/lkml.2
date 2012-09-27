Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2I0IMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:12:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61385 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab2I0IM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120927075101.GM12592@arwen.pp.htv.fi>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-8-git-send-email-andriy.shevchenko@linux.intel.com>
	<20120927075101.GM12592@arwen.pp.htv.fi>
Date: Thu, 27 Sep 2012 13:42:28 +0530
X-Google-Sender-Auth: GxAWtaIybns7Fl-ueA1dGTZ0KyM
Message-ID: <CAOh2x=njC5qUADH3DGrg602HrPaUy=Nq_eRnHwB_Lz3PE=R_xg@mail.gmail.com>
Subject: Re: [PATCHv3 7/7] MAINTAINERS: add recently created files to dw_dmac section
From: viresh kumar <viresh.kumar@linaro.org>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 1:21 PM, Felipe Balbi <balbi@ti.com> wrote:
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

:)

@Andy: It's not that i don't want anybody else to be a Maintainer of
this module, but i am
a bit confused with what is written in description of MAINTAINERS file...

M: is not considered for Mail normally, but as Maintainer - who is
bound to look and review
at all the patches, Has right to Ack or Nack something (Only if he is
on the logical side :) )

Suppose, if there are 10-20 people from different companies, who want
to have themselves
in cc for patches to a specific driver/subsystem, Will all of them add
themselves to
MAINTAINERS file? I guess NO.

If you only want yourself to be in cc, then ideally after these
patches you should be there
without these changes.

People must cc after running scripts/get_maintainers.pl and it should
return your name too,
if i am not incorrect.

But if you want to be a MAINTAINER explicitly, which i believe you are
not (looking at the commit
log), then this change is fine.

--
viresh
