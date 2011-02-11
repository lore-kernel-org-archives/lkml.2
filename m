Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab1BKQ4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 11:56:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64033 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753Ab1BKQ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 11:56:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=iwr5lvO2jnmy7FqeS2RxkmzJX6r0FQtJYCjDMPg4AQpy62A5USWDEq7LQhwJ2dD0Uq
         TG0surcBPN1SkcVLduE/5GXu9wAVAol8Ni7CM+9O0RAFhDFxqUei30Dau0qZVWpCEX9Q
         QBD0w23QogwYjaf4FNVvneo7TU5HWtBLpQZdY=
MIME-Version: 1.0
In-Reply-To: <AANLkTinJ-jvHLbXZWfQLusvFcsXw39-brz4gFF9pjQuP@mail.gmail.com>
References: <AANLkTin20CuVOpK25TTCD=195Fqktre2zWCbwC+2SPHX@mail.gmail.com> <AANLkTinJ-jvHLbXZWfQLusvFcsXw39-brz4gFF9pjQuP@mail.gmail.com>
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Fri, 11 Feb 2011 20:25:38 +0330
Message-ID: <AANLkTinBD_06pgFhjJaKUUBdaUgLVPYBjttkVkUptCaf@mail.gmail.com>
Subject: Re: ubuntu boot problem after compiling new kernel
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Chris and Anca,

I tried to compile latest kernel(2.6.37). but I receive an assembly
error: /include/trace/events/kmem.h:45: undefined reference to
'.L1747'. I didn't have any error at linux-2.6.18.1 compilation. I
read somewhere that kernel should be compiled by gcc-3.4 .  Thus I
used gcc-3.4 to compile. Do you think it's a compiler issue? Should I
use another gcc version?
Sorry for asking stupid questions from you experts. I'm a newbie at
working with kernel.

Thanks in advance

On Thu, Feb 10, 2011 at 11:41 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> On Thu, Feb 10, 2011 at 12:00 AM, Amirali Shambayati
> <amirali.shambayati@gmail.com> wrote:
>> Hello all,
>> I compiled a new kernel according to
>> http://www.howtoforge.com/kernel_compilation_ubuntu instructions. The
>> kernel version is 2.6.18.1 and I did it in ubuntu 10.04 installed on
> [snip]
>> Your help is appreciated. It's more than a week that I'm looking for a
>> solution. :-s
>
> Use this tutorial: https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
>



-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
