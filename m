Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab2HJKEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:04:48 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58950 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab2HJKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:04:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120810100233.GA1503@avionic-0098.mockup.avionic-design.de>
References: <1344573730-21907-1-git-send-email-sachin.kamat@linaro.org>
	<1344573730-21907-2-git-send-email-sachin.kamat@linaro.org>
	<20120810095536.GA20314@avionic-0098.mockup.avionic-design.de>
	<CAK9yfHwmfW9K9jBfJJXr5S1nJOsetedkEQ96Rh4DT_zvOGr4eQ@mail.gmail.com>
	<20120810100233.GA1503@avionic-0098.mockup.avionic-design.de>
Date: Fri, 10 Aug 2012 15:34:46 +0530
Message-ID: <CAK9yfHxXEBecVbiMyBKA_sHfzA1evCYeV9W66McUqZ67f2q3hA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pwm: core: Fix coding style issues
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 August 2012 15:32, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Fri, Aug 10, 2012 at 03:29:08PM +0530, Sachin Kamat wrote:
>> On 10 August 2012 15:25, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>> > On Fri, Aug 10, 2012 at 10:12:10AM +0530, Sachin Kamat wrote:
>> >> Fixes the following:
>> >> WARNING: line over 80 characters
>> >> ERROR: spaces required around that ':' (ctx:VxW)
>> >> WARNING: Prefer pr_warn(... to pr_warning(...
>> >>
>> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> >> ---
>> >>  drivers/pwm/core.c |    6 +++---
>> >>  1 files changed, 3 insertions(+), 3 deletions(-)
>> >>
>> >> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
>> >> index efc20f8..929be13 100644
>> >> --- a/drivers/pwm/core.c
>> >> +++ b/drivers/pwm/core.c
>> >> @@ -130,7 +130,7 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
>> >>  }
>> >>
>> >>  static struct pwm_device *of_pwm_simple_xlate(struct pwm_chip *pc,
>> >> -                                           const struct of_phandle_args *args)
>> >> +                                          const struct of_phandle_args *args)
>> >>  {
>> >>       struct pwm_device *pwm;
>> >>
>> >
>> > Can this hunk be removed, please? I think aligning the arguments is more
>> > useful than respecting the 80-columns limit.
>>
>> Sure, if you think so. Anyway it was just one space deleted. Do you
>> want me to re-send the patch?
>
> No, with your permission, I'll just leave that hunk out and remove the
> "WARNING: line over 80 characters" line from the commit message.

OK. That is fine with me.
Thanks.

>
> Thierry



-- 
With warm regards,
Sachin
