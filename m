Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2HAXKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:10:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33619 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab2HAXKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:10:07 -0400
MIME-Version: 1.0
In-Reply-To: <5019B36A.4030604@zytor.com>
References: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org> <5019B36A.4030604@zytor.com>
From: Meredydd Luff <meredydd@senatehouse.org>
Date: Thu, 2 Aug 2012 00:09:45 +0100
Message-ID: <CAD=T17Esguer01OsrxMtqEcHKZ-Ovg05+MxSdF7NhXENsUubgg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call (v2)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 11:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/01/2012 03:10 PM, Meredydd Luff wrote:
>> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
>> index 51171ae..c35df9e 100644
>> --- a/arch/x86/syscalls/syscall_64.tbl
>> +++ b/arch/x86/syscalls/syscall_64.tbl
>> @@ -319,6 +319,7 @@
>>  310  64      process_vm_readv        sys_process_vm_readv
>>  311  64      process_vm_writev       sys_process_vm_writev
>>  312  64      kcmp                    sys_kcmp
>> +313  64      execveat                stub_execveat
>>
>>  #
>>  # x32-specific system call numbers start at 512 to avoid cache impact
>
> I think that should be common, not 64 (as should kcmp be).

I copied the original execve, which is 64.

Meredydd
