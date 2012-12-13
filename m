Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2LMDQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:16:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53861 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2LMDQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:16:57 -0500
Message-ID: <50C9489F.3050302@gmail.com>
Date: Wed, 12 Dec 2012 20:16:47 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com> <50C94561.3070800@gmail.com> <CA+55aFwD3fFn7iYSnLw7iFk88xPYaVXMQVDyQans77PydgaeGg@mail.gmail.com>
In-Reply-To: <CA+55aFwD3fFn7iYSnLw7iFk88xPYaVXMQVDyQans77PydgaeGg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/12 8:09 PM, Linus Torvalds wrote:
> On Wed, Dec 12, 2012 at 7:02 PM, David Ahern <dsahern@gmail.com> wrote:
>>
>> Can you add -v and see if it spits out more info?
>
> No more info.

I'm surprised you are not seeing this as well:

            } else if ((err == EOPNOTSUPP) && (attr->precise_ip)) {
                 ui__error("\'precise\' request may not be supported. "
                       "Try removing 'p' modifier\n");
                 rc = -err;
                 goto out;
             }

I made changes in this area relatively recently; I'll take a look.

David


