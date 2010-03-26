Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0CZCbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 22:31:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44592 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0CZCbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 22:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Rr/iRF9MA7+hZ8pPmgVi5KS8nYnXxljELdsbjYwXYBr9w8Yb7FQsluGAvaza0tBIlZ
         8EqTRWxeQqzNu+6iawHVnQvzZpoIcs90VdkRk97OTJWS9PqGLbGi5CMykUhT5BTJsVsI
         93wwIxntxkDyCPs3yx3HRtXZWdU7aHy5GImHo=
MIME-Version: 1.0
In-Reply-To: <20100326110946V.fujita.tomonori@lab.ntt.co.jp>
References: <1269401628.18314.264.camel@localhost>
	 <20100326104042T.fujita.tomonori@lab.ntt.co.jp>
	 <21d7e9971003251845i24af9712qb64aa3ca5f8f042c@mail.gmail.com>
	 <20100326110946V.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 26 Mar 2010 12:31:30 +1000
Message-ID: <21d7e9971003251931t54c0fda7yf685f593901f2577@mail.gmail.com>
Subject: Re: [PATCH 1/2] sis-agp: Remove SIS 760, handled by amd64-agp
From: Dave Airlie <airlied@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: ben@decadent.org.uk, airlied@linux.ie, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 12:10 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Fri, 26 Mar 2010 11:45:50 +1000
> Dave Airlie <airlied@gmail.com> wrote:
>
>> On Fri, Mar 26, 2010 at 11:41 AM, FUJITA Tomonori
>> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> > On Wed, 24 Mar 2010 03:33:48 +0000
>> > Ben Hutchings <ben@decadent.org.uk> wrote:
>> >
>> >> SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
>> >> amd64-agp is apparently preferable since it has workarounds for some
>> >> BIOS misconfigurations that sis-agp doesn't handle.
>> >>
>>
>> Will this not cause problems in 32-bit kernels?
>
> I'm not sure. I thought that amd64-agp works on 32-bit kernels since
> fix_northbridge() in amd64-agp.c has the comment that the function is
> used on 64-bit and 32-bit kernels. We need someone who can test the
> patch.
>

Ah yes the amd64-agp bit scared me again, I thought it was a 64-bit only
module, but it seems to get used on 32-bit as well.

Dave.
