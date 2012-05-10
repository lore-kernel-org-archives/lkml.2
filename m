Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887Ab2EJRjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:39:35 -0400
Received: from david.siemens.de ([192.35.17.14]:18287 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380Ab2EJRjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:39:32 -0400
Message-ID: <4FABFD2A.3020706@siemens.com>
Date: Thu, 10 May 2012 14:38:50 -0300
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Anthony Liguori <aliguori@us.ibm.com>, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH v2] compat: Fix RT signal mask corruption via sigprocmask
References: <4FAAEB37.1080001@siemens.com> <CA+55aFz-z6F=ynvTZp2xrSyq+Ar7huT92_S9e8Wuxepyppq5ZQ@mail.gmail.com> <4FABBCE4.3050503@siemens.com> <CA+55aFyOsPY-RNwedb3NnbKbj=iAc7L6YuSSEZYy5_Sczmqd4A@mail.gmail.com> <CA+55aFyr4_3MN4yZdNMnDr+nKm+VTONiP6SQnAGXoaQ1egr7zQ@mail.gmail.com>
In-Reply-To: <CA+55aFyr4_3MN4yZdNMnDr+nKm+VTONiP6SQnAGXoaQ1egr7zQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-10 12:58, Linus Torvalds wrote:
> On Thu, May 10, 2012 at 8:44 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I think I'll just edit your patch directly, no need to send me a new version.
> 
> Ok, just FYI, this is the incremental diff I ended up with. I'll
> commit it as this, but I'm sending it out for people to verify before
> I do. Although just from looking at the code generation, it really
> does just change those four instructions that do a mask to a single
> 'movl', so I think it's pretty safe even though I haven't tested it.

I did, and it looks and works fine.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
