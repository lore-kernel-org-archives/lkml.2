Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2FWGCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:02:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55477 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2FWGCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:02:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120623044105.GA32663@kroah.com>
References: <CAN_1RdvqJRig8vZW_gcvNVKYNo7ROmEKxAs7qu1N6XE4+Pspjg@mail.gmail.com>
	<20120623040633.GA16278@kroah.com>
	<CAN_1RdtfiWtuqV=vBkagZfmvstket499QdCK3zZrrS8xKTZwPA@mail.gmail.com>
	<20120623044105.GA32663@kroah.com>
Date: Sat, 23 Jun 2012 14:01:59 +0800
Message-ID: <CAN_1RduD=yh0vjVdb3RwQn9ivxcBEGgJ3aTXuGgj4=FEznYmXg@mail.gmail.com>
Subject: Re: [PATCH] Implement uhook(call kernel func from userspace) driver
From: Peiyong Feng <peiyong.feng.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/23 Greg KH <gregkh@linuxfoundation.org>:
> On Sat, Jun 23, 2012 at 12:18:29PM +0800, Peiyong Feng wrote:
>> 2012/6/23 Greg KH <gregkh@linuxfoundation.org>:
>> > On Sat, Jun 23, 2012 at 11:20:35AM +0800, Peiyong Feng wrote:
>> >> Hi all,
>> >>
>> >> This patch implement the uhook kernel driver. Here are some ideals and
>> >> explanations:
>> >>
>> >> 1. What is uhook
>> >>
>> >> uhook(userspace kernel hook) means call kernel function from
>> >> userspace. That is to say, we can
>> >>
>> >> write a function in kernel space and call it in userspace while the
>> >> kernel Image is running. For example:
>> >
>> > That's, um, "interesting", but is of course, nothing we can accept into
>> > the main kernel tree, as I'm sure you can understand.  Otherwise, you
>> > just created a few thousand undocumented system calls whose behavior
>> > changes every release which is not something we can accept.
>> >
>> > But it is a great hack, very nicely done.  I'm sure that some people
>> > will like it for debugging, although I'm not quite sure you got all of
>>
>> Well, is there some other tree I can commit the patch?
>
> What do you mean by this?

I mean that although the main line kernel cannot accept this patch, and
uhook is very useful to play a rule as a debug tool. Is there some where else
that can hold this tool, and let more people use the uhook?
>
>> > the user/kernel boundry conditions correct, and I know the 32/64bit
>> > issues aren't handled, which you might want to clean up sometime in the
>>
>> I am still working on it. The ultimate aim is that the uhook module can process
>> any funciton and any data type
>
> Good luck :)
>
