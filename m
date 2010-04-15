Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0DOXnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:43:18 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:40406 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab0DOXnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:43:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=k+mgAfnkeHlkkh2ZAdV7OKvxcastsBJw8fYcWMes0RTupiFicYnok8NB18OdwwqG7g
         hwimNMWwTOrFnftLg1H1ff2eZKzzaTXH/4oLiHyNUkYbrpz/trg1fDyLDo0FeVhzIAUt
         0tLfan+gofRbQHmtMVTKab7L/JDGk2vUxWpdk=
MIME-Version: 1.0
In-Reply-To: <20100415180200.GA1443@ucw.cz>
References: <h2i45cc95261004120628kb38aabecr2552668f9e60d7c5@mail.gmail.com> 
	<20100415180200.GA1443@ucw.cz>
From: David Rees <drees76@gmail.com>
Date: Thu, 15 Apr 2010 16:42:56 -0700
Message-ID: <q2p72dbd3151004151642p9c0b8a14yc9de251b134aec08@mail.gmail.com>
Subject: Re: Low-Level and Long-Term Battery Control
To: Pavel Machek <pavel@ucw.cz>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 11:02 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> For Laptops, it is better to extract the battery from the Laptop when
>> the computer will be on power for a long period.
>> I ask if the kernel can do such control without the user intention and
>> in an automatic way.
>>
>> Some BIOS provide to the user to select whether to block the battery
>> charging to 50% to make it stand for more time.
>
> Where have you seen that?

I do recall that some older ThinkPads had a utility that would let you
determine what "empty" and "full" was by setting artificial limits.
It's well known that by keeping batteries from being fully
charged/discharged can significantly extend it's useful life although
you will suffer from shorter run-times.  How sensitive a battery is to
this depends on it's exact chemistry, but all are affected by this to
some degree.

For example, by keeping your battery from charging above 85% and below
15% can increase the number of charge/discharge cycles a large amount
often on the order of 5-10 times more charge/discharge cycles - much
more than the 30% reduction in total capacity.  Limiting to 25-75%
will help even more.

-Dave
