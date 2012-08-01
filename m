Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2HAXdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:33:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48609 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab2HAXdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:33:16 -0400
Message-ID: <5019BCA7.7060106@zytor.com>
Date: Wed, 01 Aug 2012 16:32:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Meredydd Luff <meredydd@senatehouse.org>
CC: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call (v2)
References: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org> <5019B36A.4030604@zytor.com> <CAD=T17Esguer01OsrxMtqEcHKZ-Ovg05+MxSdF7NhXENsUubgg@mail.gmail.com> <5019BC0E.4010109@zytor.com>
In-Reply-To: <5019BC0E.4010109@zytor.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 04:30 PM, H. Peter Anvin wrote:
> On 08/01/2012 04:09 PM, Meredydd Luff wrote:
>>>>  #
>>>>  # x32-specific system call numbers start at 512 to avoid cache impact
>>>
>>> I think that should be common, not 64 (as should kcmp be).
>>
>> I copied the original execve, which is 64.
>>
> 
> Sorry, you're right.  The argument vector needs compatibility support.
> 
> This means you need an x32 version of the function -- execve
> unfortunately is one of the few system calls which require a special x32
> version (although it's a simple wrapper around sys32_execve).  See
> sys_x32_execve.
> 

Err, stub_x32_execve.

	-hpa

