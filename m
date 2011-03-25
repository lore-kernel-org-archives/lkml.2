Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1CYOab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:30:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60822 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1CYOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qZbgzGgZmFJIeTYhbehNthUwWXu2NfGAonJcL4ZRO6+y4fkWfG1N23RN3y92q6HlIk
         M1oEJnEZagSm0fWafgnFkfDgXGyIALpDWHwKPEiZRGilapn5rmWQm60OPfsW5z/Dw8Ic
         u76bbx2vLstPuEW7vFfKY9kQWYRgHYAn0sD88=
MIME-Version: 1.0
In-Reply-To: <1301055960.2250.202.camel@laptop>
References: <AANLkTinCk35LSMLyO0nD+Z1ZmZskaCCN5c8kyxLcmXYx@mail.gmail.com>
	<1301055698.2250.198.camel@laptop>
	<1301055960.2250.202.camel@laptop>
Date: Fri, 25 Mar 2011 22:30:29 +0800
Message-ID: <AANLkTimw1+6DrYxxzkw7yh-t4W8rM55qcVd1nsQrAYT-@mail.gmail.com>
Subject: Re: deadlock caused by printk
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@osdl.org, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/3/25 Peter Zijlstra <peterz@infradead.org>:
>> One thing you could to is use trace_printk() and use ftrace to debug
>> perf.
>
> That should still work.

I will try it, thanks.

But seems ftrace can't dump out the messages if system hangs, so could
we introduce a smart and simple "printk" which can be used in any
contexts?

thanks,
-- 
Lei Ming
