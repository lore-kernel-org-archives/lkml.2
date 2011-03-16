Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab1CPEvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:51:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55137 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1CPEvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e+8Pmrfo6qqpYajq/21a2Q3O+8qnHgkC8u1wNUobI9mzb/Kun6u5jEdX4fWKnWD25K
         1do//GN/tkpo7m0FhcXL54LAUbqnRX+zZ/Ij7lHlx3PUhR0GvBWxxdDUdrWWsxM9XcXP
         t66QzCzvFSbzZ6zDOAuX8MBS63ElZBQflWqUg=
MIME-Version: 1.0
In-Reply-To: <201103160030.27594.vapier@gentoo.org>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103071633.08197.vapier@gentoo.org>
	<AANLkTinu_FZ2_T4N7W9qNtoatG7zQua-SYSJ0GU0cJia@mail.gmail.com>
	<201103160030.27594.vapier@gentoo.org>
Date: Tue, 15 Mar 2011 21:51:37 -0700
Message-ID: <AANLkTimk3dfOBoPhGQ8NeOYY5rKdsefPm8gTJ-75vg3-@mail.gmail.com>
Subject: Re: X32 psABI status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 9:30 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Wednesday, March 16, 2011 00:17:04 H.J. Lu wrote:
>> On Mon, Mar 7, 2011 at 1:33 PM, Mike Frysinger wrote:
>> > On Saturday, March 05, 2011 14:08:04 H.J. Lu wrote:
>> >> Many x32 bugs are fixed in kernel, glibc, binutils and GCC:
>> >>
>> >> https://sites.google.com/site/x32abi/
>> >>
>> >> The major remaining issues are glibc/gcc testsuite failures,
>> >> kernel core dump and signal handler unwind.
>> >
>> > are you getting a unique host tuple for this ?  or are you extending
>> > x86_64- linux-gnu ?  so the only way of knowing which ABI is to check
>> > for the output of the compiler+compiler flags ?
>>
>> x32 requires x32 enabled x86-64 kernel.
>
> ok, but that doesnt answer my question.  what are you passing to --target ?

See:

https://sites.google.com/site/x32abi/

You configure it as

CC="gcc -mx32" ...../configure x86_64- linux-gnu


-- 
H.J.
