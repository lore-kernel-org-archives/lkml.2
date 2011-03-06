Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1CFR26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 12:28:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37734 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1CFR2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 12:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=EL+TQx6fz+UEIyXr2SaqqGzrx8vD7cNW7RwsTydNoDlwqd5gacdomxn+8CfNQv+k7z
         UjVEhtl/54R9/nbAb+z7gHB6bW6V7cc4Q9/lWwCCS+91I/izY/sNoyFkK7yTKAU7Q23Q
         k8G3TVnCIZPQJxmBp+J0gaudfnncVcog/VZkE=
MIME-Version: 1.0
In-Reply-To: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
Date: Sun, 6 Mar 2011 09:28:54 -0800
Message-ID: <AANLkTimu5AX9krwm8E-2QAs9Zpb77ooenq=yMQfsu9Ye@mail.gmail.com>
Subject: Re: X32 psABI status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 11:08 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
> Hi,
>
> Many x32 bugs are fixed in kernel, glibc, binutils and GCC:
>
> https://sites.google.com/site/x32abi/
>
> The major remaining issues are glibc/gcc testsuite failures,
> kernel core dump and signal handler unwind.
>

I checked in a kernel patch:

http://git.kernel.org/?p=linux/kernel/git/hjl/linux-2.6.37.y.git;a=commitdiff;h=7fd04de9dca8871772d97928c338d4a2eb315c2b

and a GCC patch:

http://gcc.gnu.org/ml/gcc-patches/2011-03/msg00267.html

to fix signal handler unwind.


-- 
H.J.
