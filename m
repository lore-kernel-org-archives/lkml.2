Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1H2WZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:25:30 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57069 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab1H2WZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:25:29 -0400
Message-ID: <4E5C11D5.4020404@nod.at>
Date: Tue, 30 Aug 2011 00:25:25 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 8/9] um: fix strrchr problems
References: <1314634419-24766-1-git-send-email-richard@nod.at> <1314634419-24766-9-git-send-email-richard@nod.at> <20110829142705.5be82d7c.akpm@linux-foundation.org> <4E5C06DF.60508@nod.at> <20110829221230.GP2203@ZenIV.linux.org.uk> <4E5C0F9F.5000405@nod.at> <20110829221922.GQ2203@ZenIV.linux.org.uk>
In-Reply-To: <20110829221922.GQ2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.08.2011 00:19, schrieb Al Viro:
> On Tue, Aug 30, 2011 at 12:15:59AM +0200, Richard Weinberger wrote:
>> Am 30.08.2011 00:12, schrieb Al Viro:
>>> On Mon, Aug 29, 2011 at 11:38:39PM +0200, Richard Weinberger wrote:
>>>>>
>>>>> ok, I give up.  How does this work?
>>>>
>>>> *grrr*, you can drop this patch.
>>>> To my excuse, I've dropped it already from my queue but after
>>>> pulling a second time from Al's git branch it made it again into my
>>>> queue and I forgot about it, sorry!
>>>
>>> That gets you link errors with libc-2.11...
>>
>> Not here.
>> I'm using 2.11.3.
>
> Try to build it static...

I'm building most of the time static.
Using defconfig and
CONFIG_STATIC_LINK=y
it builds fine here (x86_64 and i386)

Thanks,
//richard
