Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2CWQrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:47:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42443 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2CWQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAEdQ38GOZi7t5BraBMhETuf=cDBVW7txkDH6guC0kZVXyqG04A@mail.gmail.com>
References: <1332249538-2610-1-git-send-email-consul.kautuk@gmail.com>
	<CAFPAmTTSrDkDLHoh0NQ8iAG-=vBXW3UwhWAXKfBa_Nk0gj07Xw@mail.gmail.com>
	<CAEdQ38G5VVoPKr1ayMZrQ2ba7xa9ofnY+TK4SUqOb8kr5fBsMQ@mail.gmail.com>
	<CAFPAmTQfbNv3A-j9OCRswj-VtB79ZLCSDdMC1KqBQdrVO6K54A@mail.gmail.com>
	<CAEdQ38GOZi7t5BraBMhETuf=cDBVW7txkDH6guC0kZVXyqG04A@mail.gmail.com>
Date: Fri, 23 Mar 2012 12:47:38 -0400
Message-ID: <CAFPAmTTwzhW-jFKhJ4_wXxb33c-MxCBGYgCTog4zasd2_G2i-w@mail.gmail.com>
Subject: Re: [PATCH 02/20] alpha/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,


On Fri, Mar 23, 2012 at 12:40 PM, Matt Turner <mattst88@gmail.com> wrote:
> On Fri, Mar 23, 2012 at 12:33 PM, Kautuk Consul <consul.kautuk@gmail.com> wrote:
>>>> Can I improve this patch in any way ?
>>>
>>> Sorry, I just don't have time. I imagine that all these patches are
>>> going upstream through the same tree, so feel free to commit this
>>> patch with the rest. If there's a problem, we'll notice it later.
>>>
>>
>> Sorry, I'm quite new to this.
>> What do you mean by : "feel free to commit this patch with the rest" ?
>>
>> Does this mean I request someone on the list (like akpm) to include
>> this patch ?
>
> Yes, exactly. :)

Can you please include this patch into linux-next whenever it is OK with you ?
