Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1BLV3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 16:29:12 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34047 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1BLV3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 16:29:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fxLci/lV1kgzE5iubzvG5YRWBiEHvLX5eeX4YFN39Uc+gG0ncsVB3SPyWqQHYZ+hPu
         12M/pYSaoN4Orp8sxtdxLAzZRwF/is0ozQSYNTZ/0gtnzUUtEBnCYqvwfIgJo18PCG8J
         ry08vhP1wmk4toJwNmDLsW61lsmQ6IBu2NXfQ=
MIME-Version: 1.0
In-Reply-To: <87aai1gdr7.fsf@mid.deneb.enyo.de>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<87aai1gdr7.fsf@mid.deneb.enyo.de>
Date: Sat, 12 Feb 2011 13:29:00 -0800
Message-ID: <AANLkTimu_VtGnNO-ySeCCE9A0fuof6GkMPUYJ65T2sCR@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 1:10 PM, Florian Weimer <fw@deneb.enyo.de> wrote:
> * H. J. Lu:
>
>> We made lots of progresses on x32 pABI:
>>
>> https://sites.google.com/site/x32abi/
>>
>> 1. Kernel interface with syscall is close to be finalized.
>> 2. GCC x32 branch is stabilizing.
>> 3. The Bionic C library works with the syscall kernel interface.
>>
>> The next major milestone will be x32 glibc port.
>
> It is a bit difficult to extract useful information from these
> resources.

That is true. Contributions are more than welcome.

> Is off_t 32 bits?  Why is the ia32 compatiblity kernel interface used?

Yes.

> I'm sure a lot of people want to get rid of that in cases where they
> control the whole software stack.

That is debatable. The current thought is the x32 user space API
is the same as is ia32.  time_t is also an issue.

> Is stack alignment to 16 bytes beneficial for X32?
>

Even ia32 uses 16byte stack alignment and we will make it
official soon via an amendment to the i386 psABI.

-- 
H.J.
