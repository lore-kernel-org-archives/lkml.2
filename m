Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab2AFCGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:06:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484Ab2AFCGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:06:41 -0500
Message-ID: <4F065704.4020306@redhat.com>
Date: Thu, 05 Jan 2012 21:05:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
References: <20120104201800.GA2587@www.outflux.net> <20120105143008.GA31728@elliptictech.com> <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com> <20120105200810.GA3826@elliptictech.com> <CAGXu5jKe_qpQ9yG4f0J_94WNKYy_qdDNdVW4v74ZivwO4Xy0Rg@mail.gmail.com>
In-Reply-To: <CAGXu5jKe_qpQ9yG4f0J_94WNKYy_qdDNdVW4v74ZivwO4Xy0Rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 03:55 PM, Kees Cook wrote:
> On Thu, Jan 5, 2012 at 12:08 PM, Nick Bowler<nbowler@elliptictech.com>  wrote:

>> But this is a brand new feature that changes longstanding behaviour of
>> various syscalls.  Making it default to enabled is rather mean to users
>> (since it will tend to get enabled by "oldconfig") and seems almost
>> guaranteed to cause regressions.
>
> I couldn't disagree more. There has been zero evidence of this change
> causing anything but regressions in _attacks_. :P If anything, I think
> there should be no CONFIG and no sysctl, and it should be entirely
> non-optional. But since this patch needs consensus, I have provided
> knobs to control it.

I agree with you, Kees.

The behaviour introduced by this patch should produce so
few issues, that the new behaviour should probably be on
by default.

The few people impacted can use a sysctl knob to disable
the check on their systems. I am not sure anyone will
actually be using that knob...

The config option is probably not needed. The new
behaviour is something that could just be on by default
for everyone, and disabled by the few (if any) people
who have some setup that breaks with it.

-- 
All rights reversed
