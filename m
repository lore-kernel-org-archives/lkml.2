Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab1FPUaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:30:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab1FPUaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lb+hG0n+9p9Gy6tChpmWRQxIg7DUR5aGauvDYRCR27Y+f9hUWHW8wk1nzwuSeFVnPV
         93+zkuu4KkF9Km5Bjv2nFJHny/AtTZlH7xbne3Ybguye2FG7G3J6lZvmOyeLgsaDA717
         UAqXLgxb4Whf6H5z07cM/Bzn/yvhSr58lbqDI=
MIME-Version: 1.0
In-Reply-To: <201106162221.53360.arnd@arndb.de>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
 <BANLkTi=iKW+XsfSBoPJmZWZOvq4RKa_Yjg@mail.gmail.com> <BANLkTim5fBUmyH-Vo+6zSgoZdXxu-Mq6OA@mail.gmail.com>
 <201106162221.53360.arnd@arndb.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 16 Jun 2011 16:29:57 -0400
X-Google-Sender-Auth: G2mB-cpjobmGvbsqIlhIFGmCcvA
Message-ID: <BANLkTin53yiG02A89tQZiZiGHs90=AcMdA@mail.gmail.com>
Subject: Re: [PATCH 5/5] kgdbts: unify/generalize gdb breakpoint adjustment
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mundt <lethal@linux-sh.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sh@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 16:21, Arnd Bergmann wrote:
> On Thursday 16 June 2011 22:07:55 Mike Frysinger wrote:
>> On Thu, Jun 16, 2011 at 16:06, Mike Frysinger wrote:
>> > On Thu, Jun 16, 2011 at 11:07, Arnd Bergmann wrote:
>> >> This patch is causing build problems now, because the instruction_pointer_set()
>> >> that is used now is only defined in asm-generic/ptrace.h, which is only
>> >> used on x86, blackfin and sparc. Every other architecture now fails to
>> >> build.
>> >
>> > a fix was already merged over two weeks ago.  so either your tree is
>> > out of date,
>> >
>> > your tree is out of date.
>>
>> blah, network died before i could finish editing this
>>
>> your tree is out of date or you're seeing a different issue and need
>> to post a full build log
>
> Ok, sorry for the noise. I've only now completed going through the build
> errors of ARM randconfig on -rc1 and obviously need to rebase my fixes.

yeah, rc1 will be busticated when building kgdb
-mike
