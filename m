Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1DHVj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:39:29 -0400
Received: from mail.aknet.ru ([78.158.192.28]:57155 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab1DHVj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:39:28 -0400
Message-ID: <4D9F805B.206@aknet.ru>
Date: Sat, 09 Apr 2011 01:38:35 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <BANLkTinfOKf+aSKy+Rj+2+v42JeGuzzrNg@mail.gmail.com> <4D9F6F6E.6040107@aknet.ru> <BANLkTimbB4rhbdTy07DuneSf=SydGYvbBA@mail.gmail.com> <4D9F7AC5.5000304@aknet.ru> <BANLkTi=C46U0Qv7HDPNs3=wMPkWq0G9zCw@mail.gmail.com>
In-Reply-To: <BANLkTi=C46U0Qv7HDPNs3=wMPkWq0G9zCw@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.04.2011 01:25, Bryan Donlan wrote:
> Using dlopen will allow you to perform the fork() prior to running the
> library's initialization code.
But I don't even need that: I init it manually, there
is no automatic ctors there.

> As I said, I can't comment on the patch - I'm not familiar with that
> part of the kernel, so I don't know what kind of races may be lurking.
> But based on Oleg's comments, it seems clear to me that implementing
> your PR_DETACH is quite a complex thing to be doing.
Yes, that's true, but treat that as my personal tour to the
kernel internals. I wasn't realizing the complexity initially,
and now its almost done, so I wonder what the result will
look like, it will it worth all the troubles.

>   It is true that
> being able to daemonize() without losing threads would be a nice thing
> to have; I just have my doubts that it's worth the potential bugs that
> such a change might introduce, when it's only needed in a somewhat
> rare case, and when perfectly good workarounds exist in userspace.
Yes, I share that concerns too. And it is very unlikely that
I will propose that patch for inclusion, but I think it is possible
to code that up small and simple, in which case maybe even
Oleg will not hate it all that much. ;))
