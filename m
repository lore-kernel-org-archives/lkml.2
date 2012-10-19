Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225Ab2JSKIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:08:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33188 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab2JSKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <20121019100123.GD4185@localhost.localdomain>
References: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
	<CAOh2x=mdtkW=a-xv1BeHxoGsgbF5s+4B8QmZBdvqnWHr30Ap2A@mail.gmail.com>
	<20121019055943.GA4185@localhost.localdomain>
	<20121019100123.GD4185@localhost.localdomain>
Date: Fri, 19 Oct 2012 15:38:30 +0530
Message-ID: <CAKohponBkH68sNCOt9RQWqLxWVoG0uLMcaxfJSfC-ANwxZ5W8Q@mail.gmail.com>
Subject: Re: [PATCH] pwm: add spear pwm driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2012 15:31, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> On Fri, Oct 19, 2012 at 11:29:43AM +0530, Shiraz HASHIM wrote:
>> On Thu, Oct 18, 2012 at 11:11:06PM +0530, viresh kumar wrote:
>> > On Thu, Oct 18, 2012 at 4:58 PM, Shiraz Hashim <shiraz.hashim@st.com> wrote:
>> > > +       pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
>> > > +       if (!pc->mmio_base)
>> > > +               return -EADDRNOTAVAIL;
>> >
>> > Just check, i believe there is a routine which will do above two in a single
>> > call..
>> >
>>
>> I would cross check.
>>
>
> Couldn't find a suitable call.

Even i couldn't :(
But i remember there was something similar.. No issues, leave it.
