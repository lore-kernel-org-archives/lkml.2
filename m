Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1ICFaN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 01:30:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50356 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1ICFaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 01:30:11 -0400
Message-ID: <4E61BB42.4090301@zytor.com>
Date: Fri, 02 Sep 2011 22:29:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de> <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de> <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com> <CAMe9rOpGxNWD=gdvyVpi7V7BrwwWrpLTWdkmTjPqJ1+SUvhA0A@mail.gmail.com> <CAMe9rOrPhCC97KV+7AO-z66XJ9R0gidTmRSLZdAOCYjGkJEdFQ@mail.gmail.com> <CA+55aFyBtp-iyexHy4ccTy-qW7KqCccFfSD5HzMD_9BaXT-wjg@mail.gmail.com> <CAMe9rOq_iXX0zcdVcCJvb=he3p4QmYKKOBB_Vf7WAz+ARz3KiA@mail.gmail.com> <4E61AD47.3040108@zytor.com> <CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com>
In-Reply-To: <CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 09:44 PM, H.J. Lu wrote:
> 
> Is there a way to support something similar to  __SNATIVE_LONG_TYPE
> and  __UNATIVE_LONG_TYPE for kernel header files.
> 

Again, what is the definition you're looking for?  We have __u64 and
__s64, but the question is what alignment those types should be using,
given that we're presumably stuck with using compat_ioctl for ioctl...

	-hpa


