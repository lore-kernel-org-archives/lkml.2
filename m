Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1ICOLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 10:11:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55302 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1ICOLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 10:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <4E61B84A.9070007@zytor.com>
References: <4E582577.2060805@zytor.com>
	<201108301409.27527.arnd@arndb.de>
	<4E5D1153.5030908@zytor.com>
	<201108311814.54906.arnd@arndb.de>
	<CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
	<CAMe9rOpGxNWD=gdvyVpi7V7BrwwWrpLTWdkmTjPqJ1+SUvhA0A@mail.gmail.com>
	<CAMe9rOrPhCC97KV+7AO-z66XJ9R0gidTmRSLZdAOCYjGkJEdFQ@mail.gmail.com>
	<CA+55aFyBtp-iyexHy4ccTy-qW7KqCccFfSD5HzMD_9BaXT-wjg@mail.gmail.com>
	<CAMe9rOq_iXX0zcdVcCJvb=he3p4QmYKKOBB_Vf7WAz+ARz3KiA@mail.gmail.com>
	<4E61AD47.3040108@zytor.com>
	<CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com>
	<4E61B84A.9070007@zytor.com>
Date: Sat, 3 Sep 2011 07:11:32 -0700
Message-ID: <CAMe9rOqS-hPHyBSvy87-_+k0NjsRgNFsc=TV4r-u22G9_--wxw@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 10:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/02/2011 09:44 PM, H.J. Lu wrote:
>>>
>>> What is the definition of these macros?
>>>
>>
>> I have
>>
>> #if defined __x86_64__ && __WORDSIZE == 32
>> #define __INO_T_TYPE          __UQUAD_TYPE
>> #define __NLINK_T_TYPE                __UQUAD_TYPE
>> #define __OFF_T_TYPE          __SQUAD_TYPE
>> #define __RLIM_T_TYPE         __UQUAD_TYPE
>> #define       __BLKCNT_T_TYPE         __SQUAD_TYPE
>> #define       __FSFILCNT_T_TYPE       __UQUAD_TYPE
>> #define       __FSBLKCNT_T_TYPE       __UQUAD_TYPE
>> #define __TIME_T_TYPE         __SQUAD_TYPE
>> #define __BLKSIZE_T_TYPE      __SQUAD_TYPE
>> #define __SUSECONDS_T_TYPE    __SQUAD_TYPE
>> #define __SNATIVE_LONG_TYPE   __SQUAD_TYPE
>> #define __UNATIVE_LONG_TYPE   __UQUAD_TYPE
>> #else
>> #define __INO_T_TYPE          __ULONGWORD_TYPE
>> #define __NLINK_T_TYPE                __UWORD_TYPE
>> #define __OFF_T_TYPE          __SLONGWORD_TYPE
>> #define __RLIM_T_TYPE         __ULONGWORD_TYPE
>> #define       __BLKCNT_T_TYPE         __SLONGWORD_TYPE
>> #define       __FSFILCNT_T_TYPE       __ULONGWORD_TYPE
>> #define       __FSBLKCNT_T_TYPE       __ULONGWORD_TYPE
>> #define __TIME_T_TYPE         __SLONGWORD_TYPE
>> #define __BLKSIZE_T_TYPE      __SLONGWORD_TYPE
>> #define __SUSECONDS_T_TYPE    __SLONGWORD_TYPE
>> #define __SNATIVE_LONG_TYPE   __SLONGWORD_TYPE
>> #define __UNATIVE_LONG_TYPE   __ULONGWORD_TYPE
>> #endif
>>
>
> I don't understand the types on the right side...
>

LONGWORD is long and QUAD is 64bit int.


-- 
H.J.
