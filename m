Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970Ab1CPERJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:17:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61688 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1CPERF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dz9yawQuOyFsVMjYYF50rL+cNBlCSxPXtqFx80Qi/K4XiBC4FAonbG6tEuOx5qDj33
         epBU43I5RGlGJUTOs64pwykvZKYE8DRmcxszqlVKN094tvL0ueu7H9DSHRcfZYwWXtyj
         hBqH3urB0M6pZveBXw6m2Ieh2cpUceqEtDJ2c=
MIME-Version: 1.0
In-Reply-To: <201103071633.08197.vapier@gentoo.org>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
	<201103071633.08197.vapier@gentoo.org>
Date: Tue, 15 Mar 2011 21:17:04 -0700
Message-ID: <AANLkTinu_FZ2_T4N7W9qNtoatG7zQua-SYSJ0GU0cJia@mail.gmail.com>
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

On Mon, Mar 7, 2011 at 1:33 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Saturday, March 05, 2011 14:08:04 H.J. Lu wrote:
>> Many x32 bugs are fixed in kernel, glibc, binutils and GCC:
>>
>> https://sites.google.com/site/x32abi/
>>
>> The major remaining issues are glibc/gcc testsuite failures,
>> kernel core dump and signal handler unwind.
>
> are you getting a unique host tuple for this ?  or are you extending x86_64-
> linux-gnu ?  so the only way of knowing which ABI is to check for the output
> of the compiler+compiler flags ?

x32 requires x32 enabled x86-64 kernel.


-- 
H.J.
