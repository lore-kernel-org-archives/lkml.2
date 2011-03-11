Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1CKArR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:47:17 -0500
Received: from smtp-out.google.com ([74.125.121.67]:52928 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab1CKArP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jLIdSCsDZ2WptWv4NN+vOvvg20CkAZcBygmWY1sXIlzzNmTw6VkVR2ukhoIrolljWY
         Cq2lKBKnBZ550zTT6Gug==
MIME-Version: 1.0
In-Reply-To: <1299803678.13462.14.camel@localhost>
References: <1299204400.2812.35.camel@localhost>
	<1299362366.2570.27.camel@localhost>
	<1299377017.2341.50.camel@localhost>
	<AANLkTimU9qV11p+wTDz4SCvaoYyxpja8tmJ5D7-ki==B@mail.gmail.com>
	<1299445446.2310.157.camel@localhost>
	<1299803678.13462.14.camel@localhost>
Date: Thu, 10 Mar 2011 16:47:11 -0800
Message-ID: <AANLkTikEr-1WU1=bOOZO6HpN_ej2OHoAXRhdyS06n4at@mail.gmail.com>
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Hugh Dickins <hughd@google.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        David Miller <davem@davemloft.net>, linux-media@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 4:34 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Sun, 2011-03-06 at 16:04 -0500, Andy Walls wrote:
>> On Sun, 2011-03-06 at 10:37 -0800, Hugh Dickins wrote:
>
>> > I do expect the underlying problem to be somewhere down the driver
>> > end, given that nobody else has been reporting these issues.  I'm
>> > hoping that once the cx18 guys have time to try to reproduce it,
>> > they'll be better able to track it down.
>
> Hi Hugh,
>
> You were correct.  The mistake was in the cx18 driver, in the last thing
> that I touched, of course.  The code causing the bug isn't anywhere
> aside from my private repo.

Thanks a lot for reporting back, Andy: relief all round.

Hugh
