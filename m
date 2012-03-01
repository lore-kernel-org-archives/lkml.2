Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2CACGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:06:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32845 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2CACF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:05:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ruan.zhengwang@gmail.com designates 10.101.136.35 as permitted sender) smtp.mail=ruan.zhengwang@gmail.com; dkim=pass header.i=ruan.zhengwang@gmail.com
Message-ID: <4F4EDA38.2070803@gmail.com>
Date: Thu, 01 Mar 2012 10:08:56 +0800
From: Zhengwang Ruan <ruan.zhengwang@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; zh-CN; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Valdis.Kletnieks@vt.edu, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Trace: initialize variable to clear warning
References: <1330420174-20537-1-git-send-email-ruan.zhengwang@gmail.com>	 <1330438591.25686.214.camel@gandalf.stny.rr.com>	 <48875.1330555230@turing-police.cc.vt.edu> <1330564158.25686.230.camel@gandalf.stny.rr.com>
In-Reply-To: <1330564158.25686.230.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




-------- Original Message --------
From: Steven Rostedt
Sent: 2012年02月29日 星期三 20时09分18秒
To: Valdis.Kletnieks
Subject: Re: [PATCH] Trace: initialize variable to clear warning
> On Wed, 2012-02-29 at 17:40 -0500, Valdis.Kletnieks@vt.edu wrote:
>> On Tue, 28 Feb 2012 09:16:31 EST, Steven Rostedt said:
>>
>>> This is a bug in gcc that's fixed in 4.6 and beyond. I don't want to
>>> remove this warning because it will hide a real bug if page2 really does
>>> become uninitialized. If 4.6 gives a warning here, then I'll fix it.
>>>> -	void *page2;
>>>> +	void *uninitialized_var(page2);
>> How would you feel about this?
>>
>> -	void *page2;
>> +	void *page2; /* gcc 4.5 bug causes incorrect "uninitialized" warning */
>>
>> or something similar?
> /* if you get a warning here, upgrade your gcc to 4.6 */
>

OK, I will resend this patch.

Thanks,
-Zhengwang

> -- Steve
>
>
>
>

