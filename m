Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2HJKvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:51:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54746 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751440Ab2HJKvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:51:35 -0400
Message-ID: <1344595893.2338.6.camel@joe2Laptop>
Subject: Re: [PATCH 2/2] pwm: core: Fix coding style issues
From: Joe Perches <joe@perches.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, patches@linaro.org
Date: Fri, 10 Aug 2012 03:51:33 -0700
In-Reply-To: <CAK9yfHxXEBecVbiMyBKA_sHfzA1evCYeV9W66McUqZ67f2q3hA@mail.gmail.com>
References: <1344573730-21907-1-git-send-email-sachin.kamat@linaro.org>
	 <1344573730-21907-2-git-send-email-sachin.kamat@linaro.org>
	 <20120810095536.GA20314@avionic-0098.mockup.avionic-design.de>
	 <CAK9yfHwmfW9K9jBfJJXr5S1nJOsetedkEQ96Rh4DT_zvOGr4eQ@mail.gmail.com>
	 <20120810100233.GA1503@avionic-0098.mockup.avionic-design.de>
	 <CAK9yfHxXEBecVbiMyBKA_sHfzA1evCYeV9W66McUqZ67f2q3hA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-10 at 15:34 +0530, Sachin Kamat wrote:
> On 10 August 2012 15:32, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > On Fri, Aug 10, 2012 at 03:29:08PM +0530, Sachin Kamat wrote:
> >> On 10 August 2012 15:25, Thierry Reding
> >> <thierry.reding@avionic-design.de> wrote:
> >> > On Fri, Aug 10, 2012 at 10:12:10AM +0530, Sachin Kamat wrote:
> >> >> Fixes the following:
> >> >> WARNING: line over 80 characters
> >> >> ERROR: spaces required around that ':' (ctx:VxW)
> >> >> WARNING: Prefer pr_warn(... to pr_warning(...
[]
> >> >> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
[]
> >> >> @@ -130,7 +130,7 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
> >> >>  }
> >> >>
> >> >>  static struct pwm_device *of_pwm_simple_xlate(struct pwm_chip *pc,
> >> >> -                                           const struct of_phandle_args *args)
> >> >> +                                          const struct of_phandle_args *args)
> >> >>  {

Another way to write this is to put the return type on a
separate line like:

type
func(args to 80,
     more args aligned to open paren...)

for this case:

static struct pwm_device *
of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)


