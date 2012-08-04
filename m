Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2HDBfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 21:35:40 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35949 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2HDBfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 21:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <501C7BC8.5020801@xenotime.net>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
	<501C66A8.5000902@xenotime.net>
	<20120804011531.GA22175@lizard>
	<501C7BC8.5020801@xenotime.net>
Date: Fri, 3 Aug 2012 18:35:36 -0700
X-Google-Sender-Auth: uVKf3No98jfI65R8lrkaHi5STRg
Message-ID: <CAGXu5jKdEUAP05U=pLPcO9wVwK8FFWH5LyvcFKv_DdPoODKNyQ@mail.gmail.com>
Subject: Re: [PATCH] pstore: fix printk format warning
From: Kees Cook <keescook@chromium.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Luck <tony.luck@intel.com>, Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 6:32 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 08/03/2012 06:15 PM, Anton Vorontsov wrote:
>
>> On Fri, Aug 03, 2012 at 05:02:48PM -0700, Randy Dunlap wrote:
>>> From: Randy Dunlap <rdunlap@xenotime.net>
>>>
>>> Fix printk format warning (on i386) in pstore:
>>>
>>> fs/pstore/ram.c:409:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>>> Acked-by: Kees Cook <keescook@chromium.org>
>>> Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
>>> ---
>>> I posted this patch on June 15 and July 23 but it has not been
>>> merged anywhere afaict, so I'm sending it directly to the man.
>>
>> (I believe it's the first time I see that patch.)
>
> That's quite possible.  When Kees acked it, he advised
> me to send it to GregKH, which I did, to no avail.
>
>
>> Btw, I see no maintainers for the pstore, and it surely no longer
>> belongs to staging. Tony, I can send patches to you, or I can create
>> a git tree (actually, I already had it for my own convenience).. So
>> how about the following patch?
>
> Thanks for adding a MAINTAINERS entry for it.
>
>> Kees, Colin, as you're also pstore authors, I assume you're interested
>> in reviewing/[n]acking any possible changes, so I also added you to
>> the M: entries, is that OK?

Cool with me; thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
