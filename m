Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1KRCrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 21:47:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:18442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab1KRCrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 21:47:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="77030314"
Message-ID: <4EC5C753.6040904@linux.intel.com>
Date: Fri, 18 Nov 2011 10:47:47 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 1/2] ramoops: use pstore interface
References: <1321478739-8978-1-git-send-email-keescook@chromium.org> <1321478739-8978-2-git-send-email-keescook@chromium.org> <4EC49D13.2010206@linux.intel.com> <CAGXu5jJfhLjBN4hEUNv5DaivJJaX5=15+JaC0VEON+mfDSeF+A@mail.gmail.com>
In-Reply-To: <CAGXu5jJfhLjBN4hEUNv5DaivJJaX5=15+JaC0VEON+mfDSeF+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>>> +       /* TODO(kees): It shouldn't be possible to remove ramoops since
>>> +        * pstore doesn't support unregistering yet. When it does, remove
>>> +        * this early return and add the unregister where noted below.
>>> +        */
>>> +       return -EBUSY;
>>
>> This style is not reasonable. Maybe it should have a better wrap.
>
> I'm not sure I understand what you mean. It's wrapped roughly to
> column 75 already. What would be better for this comment? Or did you
> mean I shouldn't have unreachable code?

I mean you shouldn't write unreachable codes. It looks weird.

>
>> BTW, you need to update Documentation/ramoops.txt
>
> Ah! Yes, thanks for the reminder.
>
> -Kees
>

